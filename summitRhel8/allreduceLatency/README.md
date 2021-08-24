
download and build

```
wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.8.tgz
tar xf osu-micro-benchmarks-5.8.tgz
module load cuda/11.4.0
mkdir build
cd build
../doConfigCuda.sh ../osu-micro-benchmarks-5.8
make -j8
```

run

```
# edit runAr.sh - search for 'edit'
./submit.sh <numNodes>
```
