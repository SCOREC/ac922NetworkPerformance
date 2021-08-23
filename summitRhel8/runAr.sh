#!/bin/bash
#BSUB -W 00:10
#BSUB -P ##edit##
#BSUB -J allreduce

bin=/path/to/mpi/collective # edit

module load cuda/11.4.0

tasks=$((CWS_NODES*6))
jsrArgs="--tasks_per_rs 1 --nrs ${tasks} --gpu_per_rs 1 --cpu_per_rs 1"
set -x

jsrun $jsrArgs --smpiargs="-gpu" $bin/osu_allreduce -d cuda \
  &> ar_n${CWS_NODES}t${tasks}.${LSB_JOBID}.out
set +x
