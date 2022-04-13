#!/bin/bash

limit=$1
total=`free -m | awk 'NR==2' | awk '{print $2}'`
free=`free -m | awk 'NR==2' | awk '{print $4}'`
used=$(($total-$free))
usage=$(awk 'BEGIN{printf "%0.0f",('$used'/'$total')*100}')

echo "==========================="
echo $(date "+%Y-%m-%d %H:%M:%S")
echo "Memory limit:$limit% usage:$usage% | [Use：${used}MB][Free：${free}MB]"

if [ $usage -ge $limit ] ; then
                sync && echo 1 > /proc/sys/vm/drop_caches
                sync && echo 2 > /proc/sys/vm/drop_caches
                sync && echo 3 > /proc/sys/vm/drop_caches
                echo "OK"
else
                echo "Not required"
fi