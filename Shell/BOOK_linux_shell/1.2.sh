#!/bin/bash
# <在终端显示输出>

#### 执行脚本
bash sample.sh # 终端执行shell便捷器，可不适用 shebang

chmod 755 sample.sh
./sample.sh

chmod a+x sample.sh
./sample.sh # 相对路径 或者 绝对路径

#### 命令分隔
echo hello
echo world
echo hello
echo world

#### 打印输出
echo "Welcome to Bash"
echo Welcome to Bash

# 错误：双引号内！具有特殊含义；如果要正常打印，需要使用转义符号 \
# 【验证】: 不会报错，双引号内可以直接使用！符号
# echo "Welcome ! to Bash"

echo Hello World! # 不适用单、双引号，也可以正常显示
echo "Hello World\!"

echo 'Welcome to Bash'

# 【异常】: 不适用引号时，分号隔断命令
#echo hello ; world  # error: 没有 world命令
echo 'hello ; world'
echo "hello ; world" # 不需要转义符号

## printf 接收引用文本 + 空格分隔的参数
# 默认打印字符末尾没有换行符，需要自行添加
# 可以不使用引号
printf "hello world"

# 参数说明
#  %s %c %d %f 都是格式替换符，定义如何打印后续参数
# %-5s 指代左对齐且宽度为5的字符串（- 左对齐； 不指明- 表示右对齐）； 宽度不足5，使用空格填充
# %-4.2f 指代左对齐且宽度为4的浮点数，且只保留两位小数
printf "%-5s %-10s %-4s\n" NO Name Mark
printf "%-5s %-10s %-4.2f\n" 1 Saratch 80.3456
printf "%-5s %-10s %-4.2f\n" 2 James 90.9989
printf "%-5s %-10s %-4.2f\n" 3 Jeff 77.564

# printf echo 的参数选项，必须出现在输出字符串之前
# -n 禁止换行
echo -n "hello "
echo "world"

# -e 使用转义符号
echo "1\t2\t3" # 直接输出 \t
echo -e "1\t2\t3"

#### 彩色输出
  # \e[1;31m 一个转义字符串，将颜色设置为红色
  # \e[0m 重置颜色
echo -e "\e[1;31m This is red text \e[0m"
echo -e "\e[1;42m Green Background \e[0m"
