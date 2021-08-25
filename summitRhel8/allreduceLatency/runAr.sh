#!/bin/bash
#BSUB -W 00:10
#BSUB -J allreduce

bin=/path/to/mpi/collective # edit

module load cuda/11.0.3

tasks=$((CWS_TASKS))
jsrArgs="--tasks_per_rs 1 --nrs ${tasks} --gpu_per_rs 1 --cpu_per_rs 1"
set -x

jsrun $jsrArgs env \
  &> ar_n${CWS_NODES}t${tasks}.${LSB_JOBID}.env

jsrun $jsrArgs $bin/osu_allreduce \
  &> ar_n${CWS_NODES}t${tasks}.${LSB_JOBID}.out

jsrun $jsrArgs --smpiargs "-gpu" $bin/osu_allreduce -d cuda \
  &> arGpu_n${CWS_NODES}t${tasks}.${LSB_JOBID}.out


set +x
