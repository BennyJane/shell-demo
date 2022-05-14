#!/bin/bash

set -e

#############################################
#        一次性查看多个文件
#############################################
# shellcheck disable=SC2067
find /target -name '*.*' -exec grep 'reg' {} +;
fint /target | xargs grep 'reg'
grep 'grep' 01.log 02.log 03.log


