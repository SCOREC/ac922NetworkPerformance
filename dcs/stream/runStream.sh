#!/bin/bash

module load xl_r/16.1.1

srun hostname -s > /tmp/hosts.$SLURM_JOB_ID
if [ "x$SLURM_NPROCS" = "x" ] 
then
  if [ "x$SLURM_NTASKS_PER_NODE" = "x" ] 
  then
    SLURM_NTASKS_PER_NODE=1
  fi
  SLURM_NPROCS=`expr $SLURM_JOB_NUM_NODES \* $SLURM_NTASKS_PER_NODE`
fi

out=stream_n${SLURM_JOB_NUM_NODES}t${SLURM_NPROCS}.${SLURM_JOB_ID}.out
set -x
mpirun --bind-to core -hostfile /tmp/hosts.$SLURM_JOB_ID -np 1 \
  env &> computeEnvRhel8.txt
mpirun --bind-to core -hostfile /tmp/hosts.$SLURM_JOB_ID -np $SLURM_NPROCS \
  ./stream &> $out
set +x

rm /tmp/hosts.$SLURM_JOB_ID
