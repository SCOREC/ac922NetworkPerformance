#!/bin/bash -ex
for i in nodes*; do echo $i; grep -A 23 ^0 $i | sed -r 's/[[:blank:]]+/,/g' > $i.csv; done
