#!/bin/bash
proj=$1
threads=$2
bsub -P $proj -nnodes 1 -env "all, CWS_NODES=1, CWS_THREADS=$2" ./runStream.sh
