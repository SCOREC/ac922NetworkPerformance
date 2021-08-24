#!/bin/bash
nodes=$1
tasks=$2
sbatch -N $nodes -n $2 -t 10 --gres=gpu:6 ./myRunAr.sh
