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
# cut指定字符取值范围的方式
  # n,n,n,n,  指定多个离散字符
  # N-  从第N个字符开始，到行尾
  # N-M 从第N个字符到第M个字符（包含M）
  # -M  从第一个字符到第M个字符（包含M）
# -f 自定义字段
cut -f filed_list filename
cut -f 2,3 filename
cut -f1 filename
cut -f2,4 filename
cut -f3 --complement filename #

cut -f2 -d ";" filename # -d 指定分隔符号

#  -c -b
cut -c 2-5 filename # 输出2-5的字符
cut -c -2 filename  # 输出前两个字符
cut filename -c 1-3,6-9 --output-delimiter ","  # 显示多组数据，指定输出分隔符号

##################################################### 【4.5 sed 】  ####################################################
#### 字符串替换；
  # sed默认只输出被替换的字符串
  # sed默认只替换每行中首次匹配到的内容
  # g 执行全局替换（每行中存在多个被匹配内容）; /Ng N指定替换的次数
sed 's/pattern/replace_string' file # 输出修改后的内容，源文件不受影响
cat file | sed 's/pattern/replace_string' # 从标准输入读取内容
cat /etc/passwd | cut -d : -f1,3 | sed 's/:/- UID: /'
cat -i 's/text/replace' file

# g
sed 's/pattern/replace_string/g' file
echo "thisIsAApplethisIsAApplethisIsAApple" | sed 's/this/THIS'
echo "thisIsAApplethisIsAApplethisIsAApple" | sed 's/this/THIS/g'
echo "thisIsAApplethisIsAApplethisIsAApple" | sed 's/this/THIS/2g'
echo "thisIsAApplethisIsAApplethisIsAApple" | sed 's/this/THIS/3g'

# 自定义分隔符号: s 后面的字符串被视为 命令分隔符
sed 's:text:replace:g'
sed 's|text|replace|g'
sed 's|te\|xt|replace|g'  # 当分隔符出现在模式中，需要使用转义符号进行转义

# 使用正则表达式: 很多符号前需要添加\
sed '/^$/d' file  # 删除空行; ^$ 匹配空行，d 声明不执行替换操作，直接删除匹配到的行
sed 's/pattern/replace_string/' -i filename # -i 就地替换，修改原文件内容
sed -i 's/\b[0-9]\{3\}\b/NUMBER/g' filename # 使用NUMBER替换所有3位数的数字字；
  # \b[0-9]\{3\}\b 匹配3位数字
  # \b 单词边界
sed -i.bak 's/\b[0-9]\{3\}\b' filename  # -i.bak 创建一个包含原始文件内容的副本
  # 已匹配字符串标记： & 指代匹配给定模式的字符串(完整的字符串)
echo "this is an example"  | sed 's/\w\+/[&]/g' # & 指代【模式】匹配到的字符串，这样可以在替换字符串时，使用已匹配到的内容
  # 字串匹配标记(\1)：\# 指代出现在 括号中的部分正则表达式（正则：子模式）所匹配到的内容
  # \(pattern\) 子模式放在使用反斜线转义的（）内部
  # 子模式匹配结果序列号从1开始，使用 \N 来指代
echo this is digit 7 in a number | sed 's/digit \([0-9]\/\1)' # 将digit 7 替换为 7； digit N -》 N
echo seven EIGTH | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'   # 调换小写字母与大小字母的位置
  # 组合多个表达式: 下面三者等效
sed 'expression' | sed 'expression' # 利用管道符组合多个sed命令
sed 'expression; expression'  # 多模式之间使用分号 ; 分割
sed -e 'expression' -e 'expression' # 使用 -e PATTERN

echo abc | sed 's/a/A/' | sed 's/c/C/'
echo abc | sed 's/a/A/;s/c/C/'
echo abc | sed -e's/a/A/'  -e 's/c/C/'

# 引用： 双引号
text=hello
echo hello world | sed "s/$text/HELLO"  # 这里要引用外部变量，不能使用单引号

##################################################### 【4.6 awk 】  ####################################################
#### 格式： awk 'BEGIN{ print "start" } pattern { commands } END{ print "end" }' file
  # awk脚本通常由3部分组成：BEGIN END 带模式匹配选项的公共语句块；三者都是可选的
  # awk采用逐行处理的方式处理文件：
    # BEGIN后的命令会先于 公共语句块执行，（每行）每次执行公共语句块 之前都会执行一次
    # 对于匹配到 PATTERN 的行，awk会对其执行PATTERN后的命令，
    # 最后，处理完整个文件后，会执行 END 之后的命令

# 单引号 | 双引号 都可以
awk 'BEGIN { statements } { statements } END { END statements }'
awk "BEGIN { statements } { statements } END { END statements }"

awk 'BEGIN { i=0 } { i++ } END { print i }' filename  # 输出文件行数
  # 在读取每一行内容前，执行BEGIN模块，常用于处理 变量初始化、打印输出表格的表头等
  # 从文件或stdin中读取一行，如果能匹配pattern，则执行后续的cmd语句块；重复该过程，直到内容被读取完毕
    # 没有pattern块，默认所有行均满足，执行{ print }
    # 模式可用：正则表达式，条件语句，行范围...
    # 当前行匹配成功，则执行 {} 中的语句
  # 当输入流读取完毕后，执行END语句块内容，用于输出所有行的分析结果
echo -e "line1\nline2\n" | awk 'BEGIN { print "Start" } { print } END { print "END" }'
  # 不带pattern的{ print }，默认打印整行

echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1,var2,var3 }'  # v1 v2 v3
  # echo 只输入一行，只执行一次
  # print 可以接收参数，参数使用逗号分隔； 参数在最后输出时，使用空格分隔
  # print 语句中，使用 双引号 来拼接多个参数
echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1 "-" var2 "-" var3 }'  # v1-v2-v3

####  补充内容
  # NR 记录编号，相当于行号
  # NF 字段数量，处理当前记录时，相当于字段数量。默认的字段分隔符是空格
  # $0 该变量包含 当前记录的文本内容
  # $1 该变量包含 第一个字段的文本内容
  # $2 该变量包含 第二个字段的文本内容

echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7" | awk '{ print "LIne no:" NR ", No of fields:" NF, "$0="$0, "$1="$1, "$2="$2, "$3="$3, "}'
  # '{ print $NF }' 打印每行最后一个字段； '{ print $(NF -1) }' 打印倒数第二个字段
awk '{ print $2, $3 }' filename
awk 'END{ print NR }' filename  # 统计行数

  # 实现每行第一个数字的累加
sed 5 | awk 'BEGIN { sum=0 ; print "Summation:" } { print $1"+"; sum+=$1 } END { print "=="; print sum}'
  # 将外部变量值传递给awk
  # -v 定义变量，可以紧跟在awk后； 或者 使用键值对模式放在末尾
VAR=10000
echo | awk -v VARIABLE=$VAR '{ print VARIABLE }'  # 紧跟在awk后面
var1="Variable1"; var2="Variable2"
echo | awk '{ print v1, v2 }' v1=$var1 v2=$var2 # 接收多个外部变量
awk '{ print v1, v2 }' v1=$var1 var2=$var2 filename # 接收来自文件内的变量


# getline 读取一行
  # awk默认读取文件中的所有行，如果只想读取某一行，可以使用getline
  # 在BEGIN中使用getline读取文件头部信息，然后在主语块中处理余下的实际数据
  # getline var 变量var包含了特定行；调用时如果不带参数，可以使用$0 $1 ...访问文本内容
seq 5 | awk 'BEGIN { getline; print "Read ahead first line", $0 } { print $0 }'

# 使用过滤模式 对待处理的行进行筛选、过滤
awk 'NR < 5'  # 行号小于5的行
awk 'NR==1, NR==4'  # 行号在1到5之间的行
awk '/linux/' # 包含模式 linux 的行（可以使用正则表达式）
awk '!/linux/'  # 不包含模式为linux的行

# 设置字段分隔符
  # 默认字段分隔符是空格， 可以使用 -F 指定不同的分隔符
  # 在BEGIN中通过 FS指定分隔符； OFS指定输出字段分隔符
awk -F: '{ print $NF }' /etc/passwd
awk 'BEGIN { FS=":" } { print $NF }' /etc/passwd

# 在awk中执行命令，并读取该命令的输出
  # "cmd" | getline output;
  # awk调用命令并读取输出，将命令放在引号内，然后利用管道将命令输出传入getline
awk 'BEGIN { FS=":" } { "grep root /etc/passwd" | getline; print $1, $6 }'

# awk的关联数组
  # 关联数组： 使用字符串作为索引的数组，通过括号中索引的形式来分辨出关联数组
  # arrayName[index]
  # arrayName[index]=value  复制操作

# awk中使用循环
  # for(i=0; i<10;i++) { print $i ;}
  # for(i in array) { print array[i]; }
awk 'BEGIN {FS=":"} {name[$1]=$5} END {for {i in name} {print i, nam[i]} }' /etc/passwd

# awk 内建字符处理函数
  # length(string)
  # index(string, search_string)
  # split(string, array, delimiter)
  # substr(string, start-position, end-position)
  # sub(regex, replacement_str, string)
  # gsub(regex, replacement_str, string)
  # match(regex, string)  检测正则表达式regex是否能够在字符串string中找到匹配；如果能，返回非0值；否则，返回0

##################################################### 【4.7 统计特定文件中的词频 】  #######################################
#### awk的关联数组，先解析文件中所有单词，然后统计每个单词出现的次数
if [ $# -ne 1 ]
then
  echo "Usage: $0 filename"
  exit -1
fi

filename=$1
egrep -o "\b[[:alpha:]]+\b" $filename | \
  awk '{ count[$0]++ }'
     END{ printf("%-14s%s\n", "Word", "Count") ;
        for(ind in count)
        { printf("%-14s%d\n", ind, count[ind]);
        }
     }
  # egrep 将文件转换为单词流，每行一个单词
  # \b[[:alpha:]]\b 能够匹配每个单词，并去除空白字符和标点符号


##################################################### 【4.9 按列合并多个文件 】  #######################################
#### paste 命令实现按列合并
  # paste file1 file2 file3 -d ","
  # -d 指定分隔符，默认是空格
  # cat命令可以按照行依次合并两个文件

##################################################### 【4.10 打印文件或行中第N个单词或列 】  #############################
#### awk
awk '{ print $5 }' filename
ls -l | awk '{ print $1 " : " $8 }'

##################################################### 【4.11 打印指定行或模式之间的文本 】  #############################
#### 根据某些条件，打印输出文件的某些行
  # awk sed grep
awk 'NR==M, NR==N' filename # 输出M-N行之间的内容, 包含M N
cat filename | awk 'NR==5, NR==10'
seq 100 | awk 'NR==4, NR==6'

awk '/start_pattern/, /end_pattern/' filename # 正则表达式
awk '/pa.*2/, /end/' file

##################################################### 【4.12 以逆序形式打印行 】  #############################
#### tac
  # tac file1 file2 ...
  # tac 默认使用 \n 作为行分隔符
  # -s 指定其他分隔符
seq 5 | tac
echo "1,2" | tac -s,

seq 5 | \
  awk '{ lifo[NR]=$0}\
   END { for(lno=NR;lno>-1;lno--){ print lifo[lno]}}'