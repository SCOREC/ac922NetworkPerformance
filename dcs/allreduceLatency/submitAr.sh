#!/bin/bash
nodes=$1
sbatch -N $nodes -n $((nodes*6)) -t 10 --gres=gpu:6 ./runAr.sh
