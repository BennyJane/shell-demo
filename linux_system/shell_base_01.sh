#!/bin/bash
set -e

echo "[输入参数个数]: $#"
echo "[对应的所有位置的参数值]: $*"
echo "[脚本执行返回结果值]: $?"
echo "[脚本名称]: $0"
echo "[脚本输入第一个参数值]: $1"

# 判断语句 -d -f -r -w -x
[ -d ../linux_system ]
echo "$?"

# 判断语句 && || !
echo "$USER"

[ "$USER" != "root" ] && echo "user" || echo "root"

# 查看内存剩余可用量
FreeMem=`free -m | grep Mem | awk '{print $4}'`
[ $FreeMem -lt 1024 ] && echo "Insufficient Memory"

DIR="/media/cdrom"
if [ ! -e $DIR ]
then
mkdir -p $DIR
fi


# 使用双分支的if条件语句来验证某台主机是否在线，然后根据返回值的结果，要么显示主机在线信息，要么显示主机不在线信息
ping -c 3 -i 0.2 -W 3 $1 &> /dev/null
if [ $? -eq 0 ]
then
  echo "Host $1 is On-line"
else
  echo "Host $1 is Off-line"
fi
# bash chkhost.sh 192.168.10.10

# 使用多分支的if条件语句来判断用户输入的分数在哪个成绩区间内


