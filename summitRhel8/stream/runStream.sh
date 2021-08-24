#!/bin/bash
#BSUB -W 00:10
#BSUB -J stream

threads=$((CWS_THREADS))
jsrArgs="--tasks_per_rs 1 --nrs 1 --gpu_per_rs 1 --cpu_per_rs ${threads}"
set -x

export OMP_NUMTHREADS=${threads}
export OMP_PROC_BIND=TRUE

jsrun $jsrArgs env \
  &> stream_n${CWS_NODES}t${threads}.${LSB_JOBID}.env

jsrun $jsrArgs  ./stream \
  &> stream_n${CWS_NODES}t${threads}.${LSB_JOBID}.out

set +x
