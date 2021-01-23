#!/bin/bash

#env
#printenv

#pgrep redis

var="value"
echo $var
echo "hello, $var"
echo "hello, ${var}s"
length=${#var}  # 获取字符串长度
echo ${#var}
echo $0 # 获取当前shell
echo ${SHELL}
echo ${PWD}
echo ${USER}
echo ${UID}



export envValue="env value"

#### 设置环境变量
  # 常见的环境变量： PATH SHELL PWD USER UID
#export "${PATH}";
#export $PATH;
#export "$PATH:/home/user/bin"


#### 检测是否为超级用户
if [ $UID -ne 0 ]; then
  echo "Non root user. Please run as root."
  else
    echo "Root user"
  fi;

# test判断，使用冒号
if test $UID -ne 0: 1
  then
    echo "Non root user. Please run as root."
  else
    echo "Root user"
  fi;


#### 修改BASH的提示字符串
  # 终端或SHELL的提示符： user@hostname:/home/$
  # 使用 PS1 环境变量修改；默认该变量存储在 ~/.bashrc

# 查看
cat ~/.bashrc | grep PS1
  # PS1='${debian_chroot:=($debian_chroot)}\u@\h:\w\$ '
  # \u 用户名； \h 主机名； \w 当前工作目录
# 修改
PS1="PROMRT>"

