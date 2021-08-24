#!/bin/bash
nodes=1
tasks=$1
sbatch -N 1 -n $1 -t 5 --gres=gpu:6 ./runStream.sh
