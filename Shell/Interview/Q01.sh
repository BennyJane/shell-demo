#!/bin/bash

set -e

#############################################
#        一次性搜索多个日志文件
#############################################
find /target -name '*.*' -exec grep 'reg' {} +;
fint /target | xargs grep 'reg'
grep 'reg' 01.log 02.log 03.log -n;
grep 'reg' targetDir -R;



#############################################
#        日志查看方法
#############################################
