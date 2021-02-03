#!/bin/bash

path=`dirname $0`

declare -A statarray

while read line; do
  ftype=$(file -b "$line" | cut -d, -f1)
  let statarray["$ftype"]++
done < <(find $path -type f -print)

for ftype in "${!statarray[@]}";
do
  echo $ftype : ${statarray["$ftype"]}
done