#!/bin/bash

#### 文件处理

##################################################### 【3.1 查找并列出文件】  #############################################
####

##################################################### 【3.2 生成任意大小的文件】  ##########################################

##################################################### 【3.3 查找并删除重复文件】  ##########################################
#### comm 用于比较 已经排序 的文件
# comm file1 file2
# 交集(intersection) 输出两个文件共有的行
# 求差(difference) 打印出指定文件中所包含的 互不相同的行
# 差集(set difference) 打印出只包含在指定文件中的行，其他文件中不含

sort A.txt -o A.txt # 将A.txt进行排序，-o 覆盖原文件
sort B.txt -o B.txt
comm A.txt B.txt                 # 对比两个有序文件内容的差异
# 结果分为三列： 第一列A文件独有的内容； 第二列B文件独有的内容； 第三列两个文件共有的内容
comm A.txt B.txt -1 -2           # 输出交集部分
comm A.txt B.txt -2 -3           # 输出A文件独有的内容
comm A.txt B.txt -1 -3           # 输出B文件独有的内容
comm A.txt B.txt -3              # 输出差集
comm A.txt B.txt -3 | tr -d '\t' # 删除空白，合并前两列内容

#### 比较多个文件
# sort file1 file2 合并多个文件,再完成排序
# - 符号，通过管道符，从stdin中读取输入
sort B.txt C.txt | comm - A.txt

##################################################### 【3.4 文件权限、所有权和粘滞位】  #####################################
#### 逻辑： 通过比较文件内容来识别重复文件，方法： 计算各个文件的[校验和]，再比较校验和是否相同

##################################################### 【3.6 文件设置为不可修改】  #########################################
#### linux中扩展文件系统支持其他属性，例如： 不可修改的文件属性

#### chatter
chatter +i file # 将文件设置为不可修改
chatter -i file # 修改文件为可修改

##################################################### 【3.7 批量生成空白文件】  #########################################

touch newFile
# 循环生成100个空白文件： test{1..200}.c test{a..z}.txt
for name in {1..100}.txt; do
  touch name
done

# touch file 如何文件已经存在，将该文件的所有时间戳都修改为当前时间
touch -a file                    # 只修改文件访问时间
touch -m file                    # 只修改文件修改时间
touch -d "Jan 20, 2010" filename # 指定具体的时间

##################################################### 【3.】  ##########################################################

ln -s target temp_link

##################################################### 【3.13 head tail】  ##############################################
head file
cat file | head
head -n 10 file
head -n -10 file
seq 11 | head -n -5

##################################################### 【3.14 列出目录】  ##############################################
ls -d */
ls -F | grep "/$"
ls -l | grep "^d"
find . -type d -maxdepth 1 -print

##################################################### 【3.15 pushd popd】  ###########################################
#### 栈结构，方便快速实现目录切换
pushd /var/www  # 向栈中添加目录，并切换到该目录
pushd /usr/src
dirs  # 查看栈中内容,从左往右索引从0开始，左侧为栈顶
pushd +3  # 切换到相应目录
popd  # 删除栈顶路径，并切换到该目录
popd +num # 弹出（删除）指定目录，并切换到该目录

#### 只有两个目录切换： cd -

##################################################### 【3.16 统计文件的行数、单词数与字符数】  ##############################


