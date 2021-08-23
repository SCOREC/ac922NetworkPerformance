#define BENCHMARK "OSU MPI%s Allreduce Latency Test"
/*
 * Copyright (C) 2002-2021 the Network-Based Computing Laboratory
 * (NBCL), The Ohio State University.
 *
 * Contact: Dr. D. K. Panda (panda@cse.ohio-state.edu)
 *
 * For detailed copyright and licensing information, please refer to the
 * copyright file COPYRIGHT in the top level OMB directory.
 */
#include <osu_util_mpi.h>
#include <malloc.h>

static double get_chunks()
{
  struct mallinfo m = mallinfo();
  return m.uordblks + m.hblkhd;
}

void recordMemUsage(double* use) { 
  double m = get_chunks();
  if(m<use[0]) use[0] = m;
  if(m>use[1]) use[1] = m;
}

int main(int argc, char *argv[])
{


    double memUsage[2] = {INT_MAX,0}; //min, max
    int i, numprocs, rank, size;
    double latency = 0.0, t_start = 0.0, t_stop = 0.0;
    double timer=0.0;
    double avg_time = 0.0, max_time = 0.0, min_time = 0.0;
    float *sendbuf, *recvbuf;
    int po_ret;
    int errors = 0;
    size_t bufsize;
    options.bench = COLLECTIVE;
    options.subtype = LAT;

    set_header(HEADER);
    set_benchmark_name("osu_allreduce");
    po_ret = process_options(argc, argv);

    if (PO_OKAY == po_ret && NONE != options.accel) {
        if (init_accel()) {
            fprintf(stderr, "Error initializing device\n");
            exit(EXIT_FAILURE);
        }
    }


    MPI_CHECK(MPI_Init(&argc, &argv));
    MPI_CHECK(MPI_Comm_rank(MPI_COMM_WORLD, &rank));
    MPI_CHECK(MPI_Comm_size(MPI_COMM_WORLD, &numprocs));

    recordMemUsage(memUsage);

    switch (po_ret) {
        case PO_BAD_USAGE:
            print_bad_usage_message(rank);
            MPI_CHECK(MPI_Finalize());
            exit(EXIT_FAILURE);
        case PO_HELP_MESSAGE:
            print_help_message(rank);
            MPI_CHECK(MPI_Finalize());
            exit(EXIT_SUCCESS);
        case PO_VERSION_MESSAGE:
            print_version_message(rank);
            MPI_CHECK(MPI_Finalize());
            exit(EXIT_SUCCESS);
        case PO_OKAY:
            break;
    }

    if (numprocs < 2) {
        if (rank == 0) {
            fprintf(stderr, "This test requires at least two processes\n");
        }

        MPI_CHECK(MPI_Finalize());
        exit(EXIT_FAILURE);
    }

    if (options.max_message_size > options.max_mem_limit) {
        if (rank == 0) {
            fprintf(stderr, "Warning! Increase the Max Memory Limit to be able to run up to %ld bytes.\n"
                            "Continuing with max message size of %ld bytes\n", 
                            options.max_message_size, options.max_mem_limit);
        }
        options.max_message_size = options.max_mem_limit;
    }

    options.min_message_size /= sizeof(float);
    if (options.min_message_size < MIN_MESSAGE_SIZE) {
        options.min_message_size = MIN_MESSAGE_SIZE;
    }

    bufsize = sizeof(float)*(options.max_message_size/sizeof(float));
    if (allocate_memory_coll((void**)&sendbuf, bufsize, options.accel)) {
        fprintf(stderr, "Could Not Allocate Memory [rank %d]\n", rank);
        MPI_CHECK(MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE));
    }
    set_buffer(sendbuf, options.accel, 1, bufsize);

    bufsize = sizeof(float)*(options.max_message_size/sizeof(float));
    if (allocate_memory_coll((void**)&recvbuf, bufsize, options.accel)) {
        fprintf(stderr, "Could Not Allocate Memory [rank %d]\n", rank);
        MPI_CHECK(MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE));
    }
    set_buffer(recvbuf, options.accel, 0, bufsize);

    print_preamble(rank);


    for (size=options.min_message_size; size*sizeof(float) <= options.max_message_size; size *= 2) {

        if (size > LARGE_MESSAGE_SIZE) {
            options.skip = options.skip_large;
            options.iterations = options.iterations_large;
        }

        MPI_CHECK(MPI_Barrier(MPI_COMM_WORLD));

        timer=0.0;
        for (i=0; i < options.iterations + options.skip ; i++) {
            if (options.validate) {
                set_buffer_float(sendbuf, 1, size, i, options.accel);
                set_buffer_float(recvbuf, 0, size, i, options.accel);
                MPI_CHECK(MPI_Barrier(MPI_COMM_WORLD));
            }
            t_start = MPI_Wtime();
            MPI_CHECK(MPI_Allreduce(sendbuf, recvbuf, size, MPI_FLOAT, MPI_SUM, MPI_COMM_WORLD ));
            t_stop=MPI_Wtime();
         
            recordMemUsage(memUsage);

            if (options.validate) {
                errors += validate_reduction(recvbuf, size, i, numprocs, options.accel);
            }

            if (i>=options.skip){
                timer+=t_stop-t_start;
            }
            MPI_CHECK(MPI_Barrier(MPI_COMM_WORLD));
        }
        latency = (double)(timer * 1e6) / options.iterations;

        MPI_CHECK(MPI_Reduce(&latency, &min_time, 1, MPI_DOUBLE, MPI_MIN, 0,
                MPI_COMM_WORLD));
        MPI_CHECK(MPI_Reduce(&latency, &max_time, 1, MPI_DOUBLE, MPI_MAX, 0,
                MPI_COMM_WORLD));
        MPI_CHECK(MPI_Reduce(&latency, &avg_time, 1, MPI_DOUBLE, MPI_SUM, 0,
                MPI_COMM_WORLD));
        avg_time = avg_time/numprocs;

        if (options.validate) {
            print_stats_validate(rank, size * sizeof(float), avg_time, min_time,
                                max_time, errors);
        } else {
            print_stats(rank, size * sizeof(float), avg_time, min_time, max_time);
        }
        MPI_CHECK(MPI_Barrier(MPI_COMM_WORLD));
    }

    recordMemUsage(memUsage);

    free_buffer(sendbuf, options.accel);
    free_buffer(recvbuf, options.accel);

    recordMemUsage(memUsage);

    fprintf(stderr, "%d malloc used min max %f %f\n", rank, memUsage[0], memUsage[1]);

    MPI_CHECK(MPI_Finalize());

    if (NONE != options.accel) {
        if (cleanup_accel()) {
            fprintf(stderr, "Error cleaning up device\n");
            exit(EXIT_FAILURE);
        }
    }

    return EXIT_SUCCESS;
}
