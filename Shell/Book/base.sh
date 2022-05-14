#!/bin/bash

#### let (()) []

# let 直接执行基本的数学运算，变量名之前不需要再添加$
var1=1
var2=2
# shellcheck disable=SC2219
let result=var1+var2
let var1++  # 自增
let var1-- # 自减
let var1+=6 # 累加 let var1=var1+6
let var1-=6 # 累减 let var2=var2-6

# []符号: $符号放在中括号外部；内部变量引用可以不适用$,也可以使用
result=$[ var1 + var2 ]
result=$[ $var1 + 60 ]
echo $result



echo hello;
echo "hello; world."

echo "hello world - !"
echo "hello world !!!"

printf "hello \n"
printf "hello \n"

printf "%-5s %-10s %-4s\n" NO Name Mark



set -e

# 登录远程服务器
ssh ubuntu@IP

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

