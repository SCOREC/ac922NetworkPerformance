#!/bin/bash

module load spectrum-mpi/10.4

bin=/gpfs/u/home/CCNI/CCNIsmth/barn-shared/CWS/ac922NetworkPerformance/build-osu-xl1611-spectrum104-cuda112/mpi/collective

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
outGpu=arGpu_n${SLURM_JOB_NUM_NODES}t${SLURM_NPROCS}.${SLURM_JOB_ID}.out
set -x
mpirun -gpu -hostfile /tmp/hosts.$SLURM_JOB_ID -np 1 \
  env &> computeEnvRhel8.txt
mpirun --bind-to core -hostfile /tmp/hosts.$SLURM_JOB_ID -np $SLURM_NPROCS \
  $bin/osu_allreduce &> $out
mpirun --bind-to core -gpu -hostfile /tmp/hosts.$SLURM_JOB_ID -np $SLURM_NPROCS \
  $bin/osu_allreduce -d cuda &> $outGpu
set +x

rm /tmp/hosts.$SLURM_JOB_ID
