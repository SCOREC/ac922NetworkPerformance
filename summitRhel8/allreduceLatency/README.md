
download and build

```
wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.8.tgz
tar xf osu-micro-benchmarks-5.8.tgz
ln -snf $PWD/allreduceLatency/osu_allreduce.c osu-micro-benchmarks-5.8/mpi/collective/.
module load cuda/11.0.3 #spectrum-mpi/10.4.0.3-20210112 and xl/16.1.1-10 are loaded by default
mkdir build
cd build
../doConfigCuda.sh ../osu-micro-benchmarks-5.8
make -j8
```

run

```
# edit runAr.sh - search for 'edit'
./submit.sh <numNodes> <numTotalRanks> <project>
```
