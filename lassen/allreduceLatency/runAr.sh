#!/bin/bash
#BSUB -W 20
#BSUB -G ceed

check_sierra_nodes

bin=/g/g19/smith516/develop/osu-micro-benchmarks-5.6.1/xl19-cuda101168-spectrum-install/libexec/osu-micro-benchmarks/mpi/collective

module swap cuda cuda/10.1.168

tasks=$((CWS_NODES*4))
jsrArgs="--tasks_per_rs 1 --nrs ${tasks} --gpu_per_rs 1 --cpu_per_rs 1"
mpiArgs="--smpiargs='-gpu'"
set -x
jsrun $jsrArgs $mpiArgs $bin/osu_allreduce -d cuda \
  &> ar_n${CWS_NODES}t${tasks}.${LSB_JOBID}.out
set +x
