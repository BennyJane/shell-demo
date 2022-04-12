#!/bin/bash

##################################################### 【删除jenkins所有构建历史】  ########################################
targetPath="/var/lib/jenkins/jobs/"
cd $targetPath

for dir in ./*
do
  cd $targetPath
  cd  "$dir"  #  "$dir" 加双引号 防止路径中有空格导致失效
  cd builds
  echo "$pwd"
  rm rf * # 删除当前目录下所有内容
done

##################################################### 【删除jenkins日志】  ########################################
# https://www.cnblogs.com/chenpingzhao/p/10020028.html
#而且我们将已经定位到的文件删除掉，仍然不能释放空间，经过查看可以深层次发现其中的问题。

#在Linux或者Unix系统中，通过rm或者文件管理器删除文件将会从文件系统的文件夹结构上解除链接(unlink).
# 然而假设文件是被打开的（有一个进程正在使用），那么进程将仍然能够读取该文件，磁盘空间也一直被占用。
# 而我删除的是jenkins的日志文件，如果jenkins服务没有停止，此时删除该文件并不会起到什么作用。
# 因为删除的时候文件正在被使用，当linux打开一个文件的时候,
# Linux内核会为每个进程在/proc/ 『/proc/nnnn/fd/文件夹（nnnn为pid）』建立一个以其pid为名的文件夹用来保存进程的相关信息，
# 而其子文件夹fd保存的是该进程打开的全部文件的fd（fd：file descriptor）。

# 查看文件是否已经被删除 https://segmentfault.com/a/1190000017838653
lsof | grep deleted

# 重新启动jenkins
sudo service jenkins stop
sudo serivce jenkins start