#!/bin/bash
nodes=$1
sbatch -N $nodes -n $((nodes*4)) -t 10 --gres=gpu:4 ./runAr.sh
