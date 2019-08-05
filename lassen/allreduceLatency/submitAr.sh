#!/bin/bash
bsub -nnodes $1 -env "all, CWS_NODES=$1" -q pbatch < runAr.sh
