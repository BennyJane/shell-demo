#!/bin/bash

#### 9.明察秋毫

##################################################### 【9.1 简介】  #####################################################
####

##################################################### 【9.2 监视磁盘使用情况】  ############################################
#### du （disk usage） 使用该命令，需要对所有文件有读权限，对所有目录有读、执行权限，否则抛出错误
#### du命令输出文件的字节数，这个数字未必和文件占用的磁盘空间一致。磁盘空间以 块 为单位分配，因此 1 字节的问价也会耗费一个磁盘块，块大小通常在512到4096字节之间
  # du FILENAME FILENAME2 ...  查看指定文件占用的磁盘空间
  # du -a DIRECTORY 查看某个目录中所有文件的磁盘使用情况，每一行显示各个文件的具体情况； -a 递归的输出指定目录或多目录中所有文件的统计结果
  # du DIRECTORY 只显示子目录使用的磁盘空间，不会显示每个文件的占用情况
  # -h 使用KB MB GB为单位显示磁盘使用情况；默认使用文件占用的总字符数
  # -c 计算文件或目录所占总的磁盘空间，还会输出单个文件的大小; 可集合 -h -a 使用
  # -s 只输出总计数据
  # -b -k -m 强制使用特定的单位输出结果，不可以和-h一起使用；-b 字节为单位 -k KB为单位 -m MB为单位 -B 指定块为单位
  # --exclude --exclude-from 让du在磁盘使用统计中排除部分文件
  # --max-depth 限制遍历的子目录层数

du --exclude "wildcade" direction # 结合通配符,排序一个或多个文件
du --exclude "*.txt" *

ls *.txt >EXCLUDE.txt
ls *.odt >>EXCLUDE.txt
du --exclude-from EXCLUDE.txt direction

## 找出指定目录下最大的10个文件
du -ak SOURCE_DIR | sort -nrk 1 | head
  # du -ak -a 显示所有文件以及目录，-k 文件大小以KB显示
  # sort -nrk 1 -n 指明按数值排序 -r 逆序排列(默认升序排列) 1 使用第一列的值进行排序

find . -type f -exec du -k {} \; | sort -nrk 1 | head # 只针对文件进行排列
find . -type d -exec du -k {} \; | sort -nrk 1 | head # 只针对目录进行排列

#### df （disk free） 输出磁盘可用空间信息
  # df -h
  # df -h dir   # 输出目录所在分区的磁盘空间使用情况


##################################################### 【9.3 计算命令执行时间】  ############################################
#### time application
  # time 命令会执行 application，当其执行完毕后，time命令将其real时间、sys时间以及user时间输出到stderr中，将application的正常输出发送到stdout
  # time 命令的可执行文件位于 /usr/bin/time
  # -o 将统计的时间信息写入到文件中
  # -f 指定输出安歇统计信息以及格式：格式为 包含一个或多个%为前缀的参数
    # real %e
    # user %U
    # sys %S
    # 系统分页大小 %Z
time ls
time -o used_time.txt ls
/usr/bin/time ls