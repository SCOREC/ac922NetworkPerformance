#!/bin/bash
bsub -P $3 -nnodes $1 -env "all, CWS_NODES=$1, CWS_TASKS=$2" ./runAr.sh
