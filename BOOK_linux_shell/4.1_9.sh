#!/bin/bash

#### 让文本飞
#### sed awk grep cut

##################################################### 【4.2 使用正则表达式】  #############################################
#### 正则表达式规则
  # ^ $
  # A字符 . [] [^]
  # ? + *  {n} {n,} {n,m}
  # () | \
# 匹配邮箱：[a-z0-9_]+@[a-z0-9]+\.[a-z]+
# 匹配任意单词： ( +[a-zA-Z]+ +)   无法匹配句尾、逗号前单词
# 匹配任意单词(含句尾): ( +[a-zA-Z]+[?,.]? +)
# 匹配IP地址：[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}
# 匹配IP地址：[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}

##################################################### 【4.3 grep】  ####################################################
# stdin
echo -e "this is a word\nnext line" | grep word
# grep pattern filename 或者  grep "pattern" filename
grep "match_text" file1 file2 file3 ...
grep --color=auto world filename  # --color 高亮标记匹配到的内容
grep -E "pattern" filename  # -E 使用扩展正则表达式
egrep "pattern" file  # 使用扩展正则表达式
grep -E "[a-z]" file
egrep "[a-z]+" file
grep -o "pattern" file  # 只输出匹配到的文件
grep -v "pattern" file  # 输出不匹配pattern的所有行；获取相反的结果
grep -c "pattern" file  # 统计匹配到的行数（不是次数）,单行多次匹配只被记录一次
# 统计匹配到的项目数量
echo -e "1 2 3\nhello \n 5 6" | egrep -o "[0-9]" | wc -l
grep -n "pattern" file  # 输出匹配到的项目所在行号
grep -b -o "pattern" file   # -b 打印出匹配项目在行中的偏移量，从0开始计算
grep -l "pattern" file1 file2  # 列出匹配到内容的文件
grep -L "pattern" file1 file2  # 列出没有匹配到内容的文件

## 补充内容
grep "pattern" . -R -n  # 递归搜索多个文件
  # 等效操作： find . -type f | xargs grep "pattern"
echo hello world | grep -i "HELLO"  # 忽略大小写
grep -e "pattern1" -e "pattern1"  # 指定多个匹配模式，任意匹配上即可，就会输出
grep -f pattern_filesource file # 从文件中读取匹配模式，一个模式占一行
grep "main()" . -r --inclue *.{c, cpp}  # --include 递归搜索所有.c .cpp文件. 限定内容
  # some{string1, string2} 会被扩展为 somestring1. somestring2
grep "main()" . -r --exclude "README" # 排除指定文件
grep "main()" . -r --exclude-dir "README" # 排除指定目录
grep "main()" . -r --exclude-from file # 从文件中读取排除文件列表


##################################################### 【4.4 cut 】  ####################################################
# -f 自定义字段
cut -f filed_list filename
cut -f 2,3 filename
cut -f1 filename
cut -f2,4 filename
cut -f3 --complement filename

cut -f2 -d ";" filename

#  -c -b
cut -c 2-5 filename
cut -c -2 filename
cut filename -c 1-3,6-9 --output-delimiter ","

##################################################### 【4.5 sed 】  ####################################################
#### 字符串替换
