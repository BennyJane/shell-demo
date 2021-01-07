#!/bin/bash

set -e

#############################################
#        查询运行的进程，并完成批量删除
#############################################
# root用户相关的进程信息，显示CMD
top -u root -c
# 获取目标CMD ==》 对应多个进程PID
# cut：按字符分割，取前5个字符(从1开始), tail从末尾取10个，避免列名PID
ps -C "CMD" | cut -c 1-5 | tail -n 10

kill -9 $(ps -C "CMD" | cut -c 1-5 | tail -n 10)
kill -9 $(ps -C "CMD" | cut -c 1-5 | tail -n 10)

# 使用PPID杀死一批进程
kill -9 $(ps -ef | grep "blog" | awk '{print $3}')
