#!/bin/bash

##################################################### 【2.4 查找并列出文件】  #############################################
#### find


## 基于目录深度的搜索
  # find 默认遍历所有的子目录，不会检索符号链接； -L选项强制检测符号链接， 碰上自身的链接，会陷入死循环
  # -maxdepth: 限制find遍历目录的深度，最好放在find参数的前列，率先缩小搜素范围，提高搜索效率
  # -mindepth：设置find开始搜索的最小目录深度(距离当前目录的目录层级数目)

find -L /proc -maxdepth 1 -name 'bundlemaker.def' 2>/dev/null
  # -L 跟随符号链接
  # -maxdepth 1 将搜索范围仅限制在当前目录
  # -name 指定目录文件名称
  # 2>/dev/null 将有关循环链接的错误信息发送到空设备中
find . -mindepth 2 -name "f*" -print
  # -mindepth 2 搜索距离当前文件目录至少两个子目录的目录
  # -name 匹配以f开头的文件
  # -print 打印输出

## 区分文件类型
find . -type d -print # 目录
find . -type f -print # 普通文件
find . -type l -print # 符号链接
find . -type c -print # 字符设备
find . -type b -print # 块设备
find . -type s -print # 套接字
find . -type p -print # FIFO

## 文件时间戳
  # 默认以天为单位, +n 超过指定时间， -n 小于指定时间，n 恰好等于指定时间
  # -atime  用户最近一次访问的时间
  # -mtime  文件内容最后一次被修改的时间
  # -ctime  文件元数据(权限、所有权)最后一次改变的时间

  # 以分钟为单位
  # -amin(访问时间) -mmin(修改时间) -cmin(变化时间)

  # -newer 指定一个用于比较 修改时间 的文件， 查找比该文件更新(修改时间距离当前时间更近)的文件
find . -type f -actime -7 -print  # 查找最近7天被访问过的文件
find . -type f -actime 7 -print # 查找距离今天第7天被访问过的文件
find . -type f -actime +7 -print  # 查找最后访问时间超过7天的文件

find . -type f -mmin +7 -print
find . -type f -newer file.txt -print


#### 文件大小 -size
  # b 块（512字节）
  # c 字节
  # w 字（2字节）
  # k 千字节(1024字节)
  # M 兆字节(1024K字节)
  # G 吉字节(1024M字节)

find . -type f -size +2k  # 搜索文件尺寸大于2k
find . -type f -size -2k  # 小于2k
find . -type f -size 2k # 等于2k


#### 文件权限与所有权 -perm
  # -perm 查找指定权限的文件
  # -user 查找属于指定用户的文件

# 查找文件权限不是644的php文件对象
find . -type f -name "*.php" != -perm 644 -print
find , -type f -user targetUser -print


#### 查找后，直接执行命令 -exec
  # -delete 删除匹配到的文件
  # -exec 基于查询结果执行操作命令， 使用{}指代查找到的文件名称，末尾一般是 \; 表示-exec命令的结尾，而非find命令的结尾 ==》 必须使用转义符号
    # -exec 只能执行单个命令（多命令，可借用脚本实现）
find . -type f -name "*.swp" -delete  # 删除所有名称包含.swp的文件
# 查找root用户的文件，并将所有者修改为benny
find . -type f -user root -exec chown benny {} \;
find . -type f -user root -exec chown benny {} +  # 当-exec后命令接收多个参数，可以通过使用+，优化性能

# 将所有c文件拼接起来写入单个文件内
# find 指定结果输出只有一个数据流(stdin),所以不需要使用 >>
find . -type f -name '*.c' -exec {} \; >all_c_file.txt
find . -type f -name '*.c' -exec {} >all_c_file.txt \;
find . -type f -name '*.c' -exec {} >all_c_file.txt +

# 将修改时间超过10天的文件复制到目录/home/benny中
find . -type f -name '*.txt' -mtime +10 -exec cp {} /home/benny \;
find . -type f -name '*.txt' -exec printf "Text file: %s\n" {} \;


#### 跳过指定目录 修剪 -prune
  # -name '' -prune 跳过.git目录
find . -name '.git' -prune -o -type f -print






