
build

```
#the L3 cache on P9 is 10MB
xlc_r -O3 -DNTIMES=20 -DSTREAM_ARRAY_SIZE=$((5*10*1024*1024)) stream.c -o stream
```

run

```
#replace proj with the name of the project the job is using
./submitStream.sh proj 6
```
