#!/bin/bash -e
cat /dev/null > all.csv
for i in ar_*; do
  echo $i >> all.csv;
  grep '^[0-9]' $i | sed -r 's/[[:blank:]]+/,/g' >> all.csv;
done
