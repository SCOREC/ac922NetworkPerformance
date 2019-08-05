#!/bin/bash -ex
count=0
pasteargs=""
for i in {2..7}; do
  n=$((2**i))
  t=$((n*4))
  f=ar_n${n}*
  if [ $count = 0 ]; then
    echo 'size (B)' > sizes
    grep '^[0-9]' $f | awk '{print $1}' >> sizes
    pasteargs="$pasteargs sizes"
  fi
  echo $n > ${n}
  grep '^[0-9]' $f | awk '{print $2}' >> ${n}
  count=$((count+1))
  pasteargs="$pasteargs $n"
done
paste -d "," $pasteargs > all.csv
