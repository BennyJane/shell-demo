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

#############################################
#        shell通配符的使用: 批量删除文件；批量移动文件
#############################################
# * 匹配任意数量的任意字符
ls *.txt             # 等效操作： ls | grep .txt
rm -f *.txt          # 批量删除
mv *.txt /target/dir # 批量移动

#############################################
#        创建新文件的多种操作
#############################################
vi file.txt # vim  另存为:w /path/filename
touch file.txt

echo "content" >file.txt
echo "new_content" >>file.txt

# 将文件重定向到新的文件
cat first.txt >second.txt
less first.txt >second.txt
more first.txt >second.txt

# 将多个文件合并到新文件
cat file1 file2 >targetFile

# cd 切换目录==》 关键是重定向符号
cd >filenae
cd >>filename

#############################################
#        cut：根据单个字符对每行数据进行分割提取
#############################################
who | cut -b 3
who | cut -b -10

who | cut -c 1-5
who | cut -bn 1-3

cut -d ' ' -f 1 target.txt
cut -d : -f 1,2 target.txt
cut -f 1,2 target.txt # 默认按照制表符分隔开
