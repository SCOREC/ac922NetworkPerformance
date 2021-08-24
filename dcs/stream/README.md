
build

```
module load xl_r/16.1.1
#the L3 cache on P9 is 10MB
xlc_r -O3 -DNTIMES=20 -DSTREAM_ARRAY_SIZE=$((5*10*1024*1024)) stream.c -o stream
```

run

```
./submitStream.sh 6
```
