
download and build

```
wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.8.tgz
tar xf osu-micro-benchmarks-5.8.tgz
ln -snf $PWD/allreduceLatency/osu_allreduce.c osu-micro-benchmarks-5.8/mpi/collective/.
module load spectrum-mpi/10.4 cuda/11.2
mkdir build
cd build
../doConfigCuda.sh ../osu-micro-benchmarks-5.8
make -j8
```

run

```
# edit runAr.sh - search for 'edit'
./submitAr.sh <numNodes>
```
