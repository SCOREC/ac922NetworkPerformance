#!/bin/bash

module load spectrum-mpi/10.3

bin=/gpfs/u/barn/CCNI/shared/CWS/ac922NetworkPerformance/osu-micro-benchmarks-5.6.1/xl161-cuda100-spectrum-install/libexec/osu-micro-benchmarks/mpi/collective

srun hostname -s > /tmp/hosts.$SLURM_JOB_ID
if [ "x$SLURM_NPROCS" = "x" ] 
then
  if [ "x$SLURM_NTASKS_PER_NODE" = "x" ] 
  then
    SLURM_NTASKS_PER_NODE=1
  fi
  SLURM_NPROCS=`expr $SLURM_JOB_NUM_NODES \* $SLURM_NTASKS_PER_NODE`
fi

out=ar_n${SLURM_JOB_NUM_NODES}t${SLURM_NPROCS}.${SLURM_JOB_ID}.out
set -x
mpirun -gpu -hostfile /tmp/hosts.$SLURM_JOB_ID -np 1 \
  env &> computeEnv.txt
mpirun -gpu -hostfile /tmp/hosts.$SLURM_JOB_ID -np $SLURM_NPROCS \
  $bin/osu_allreduce -d cuda &> $out
set +x

rm /tmp/hosts.$SLURM_JOB_ID
