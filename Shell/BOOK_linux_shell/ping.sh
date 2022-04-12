#!/bin/bash

for ip in 192.168.0.{1...255} ;
do
  ping $ip -c 2 &> /dev/null ;
  if [ $? -eq 0 ] ;
  then
    ehco $ip is alive
  fi
done

# 使用多进程
for ip in 192.168.0.{1...255} ;
do
  (
  ping $ip -c 2 &> /dev/null ;
  if [ $? -eq 0 ] ;
  then
    ehco $ip is alive
  fi
  ) & # () 中命令会在子shell中执行，& 会将其置入后台
done
wait


# fping 需要安装该软件
# -a 指定显示出所有活动主机的IP地址
# -u 显示所有不可达的主机
# -g 指定从 "IP地址/子网掩码" 记法 或 “IP地址范围” 记法中生成一组IP地址
fping -a 192.160.1/24 -g
fping -a 192.160.0.1 192.168.0.255 -g
fping -a 192.160.0.1 192.160.0.2 192.160.0.6  # 从命令行接收多个IP地址
fping -a < ip.list.txt  # 从文件中读取一组IP地址


