#!/bin/bash
#BSUB -W 20
#BSUB -G ceed

check_sierra_nodes

#bin=/g/g19/smith516/develop/osu-micro-benchmarks-5.6.1/xl19-spectrum-install/libexec/osu-micro-benchmarks/mpi/pt2pt/
bin=/g/g19/smith516/develop/osu-micro-benchmarks-5.6.1/xl19-cuda101168-spectrum-install/libexec/osu-micro-benchmarks/mpi/pt2pt/

module swap cuda cuda/10.1.168

env

rsph=2
[[ ${CWS_NODES} = 2 ]] && echo foo && rsph=1

set -x
jsrArgs="--tasks_per_rs 1 --nrs 2 --gpu_per_rs 2 --cpu_per_rs 1"
mpiArgs="--smpiargs='-gpu'"
binArgs="-d cuda"
out=nodes${CWS_NODES}_DD_GPUGPU_$LSB_JOBID
jsrun $jsrArgs $mpiArgs --latency_priority gpu-gpu --erf_output ${out}.erf \
  $bin/osu_latency $binArgs D D &> ${out}.out
out=nodes${CWS_NODES}_DD_GPUCPU_$LSB_JOBID
jsrun $jsrArgs $mpiArgs --latency_priority gpu-cpu --erf_output ${out}.erf \
  $bin/osu_latency $binArgs D D &> ${out}.out
#jsrun $jsrArgs $mpiArgs $bin/osu_latency $binArgs H D &> nodes${CWS_NODES}_HD_$LSB_JOBID.out
#jsrun $jsrArgs $mpiArgs $bin/osu_latency $binArgs D H &> nodes${CWS_NODES}_DH_$LSB_JOBID.out
#jsrun $jsrArgs $mpiArgs $bin/osu_latency $binArgs H H &> nodes${CWS_NODES}_HH_$LSB_JOBID.out
set +x
