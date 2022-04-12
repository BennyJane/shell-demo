#!/bin/bash


# 利用源代码构建并安装程序时，通常需要为新的可执行文件和库文件添加特定的路径
  # 假设： myapp 安装到/opt/myapp, 二进制文件在/opt/myapp/bin目录中，库文件在/opt/myapp/lib目录中
export PATH=/opt/myapp/bin:$PATH
export LD_LIBRARY_PATH=/opt/myapp/lib; $LD_LIBRARY_PATH

#### 使用函数定义环境变量
  # 在~/.bashrc 文件中定义如下函数
  # -d 检测目录是否存在
  # eval 合并输入的$1 $2的值
  # 当$1为空值，末尾多出一个 : 冒号
prepend() { [ -d "$2" ] && eval $1=\"$2':'\$$1\" && export $1; }
  # 修改BUG
  # 使用shell参数扩展： ${parameter:=expression} 当parameter有值且不为空时，则使用expression的值
prependPlus() { [ -d "$2" ] && eval $1=\"$2\$\{$1:+':'\$$1\}\" && export $1 ; }

# 使用方式
prepend PATH /opt/myapp/bin
prepend LD_LIBRARY_PATH /opt/myapp/lib

##################################################### 【1.5 数学运算】  ##################################################

#### let $(()) $[] expr : 全部不支持浮点数计算
#### bc 支持浮点数计算

# let 直接执行基本的数学运算，变量名之前不需要再添加$
var1=1
var2=2
# shellcheck disable=SC2219
let result=var1+var2
let var1++  # 自增
let var1-- # 自减
let var1+=6 # 累加 let var1=var1+6
let var1-=6 # 累减 let var2=var2-6

# $[]符号: $符号放在中括号外部；内部变量引用可以不适用$,也可以使用
result=$[ var1 + var2 ]
result=$[ $var1 + 60 ]
echo $result

# $(()): 双括号前必须加$, 内部变量可以使用$,也可以不使用
result=$(( var1 + 10 ))
result=$(( $var1 - 10 ))
echo $result

# expr: 使用反引号`` 或者 $()来执行内部代码
result=`expr 3 + 4`
result=$(expr $var1 + 100)
echo $result

# dc: 进行浮点数计算； 提供其他高级函数
echo "4 * 0.5"  # 输出原始字符串
echo "4 * 0.5" | bc # 输出计算结果
  # 添加操作控制前缀，使用分号; 隔开
  # 设定小数精度： scale=2; 保留两位小数
  # 进制转换：obase=10;ibase=2 目标进制;原始进制
  # 平方与平方根
echo "scale=2;22/7" | bc
echo "obase=2;10" | bc  # 10转2进制
echo "obase=10;ibase=2;1100100" | bc  # 2转10进制
echo "sqrt(100)" | bc # 计算平方根
echo "10^10" | bc   # 计算平方

##################################################### 【1.6 文件描述符与重定向】  #########################################

#### 文件描述符是与 输入与输出流 相相关联的整数
  # 0 stdin 标准输入  1 stdout 标准输出  2 stderr 标准错误输出
  # 命令执行产生错误信息时，该信息会被输出到 stderr 流; 非错误信息，默认输出到 stdout 流
  # > >> 默认只输出 标准输出流 的内容，错误信息不会被传递
  # /dev/stdin /dev/stdout /dev/stderr
  # > 等效 1> ; >> 等效 1>>

# 将标准输出 到 指定文件
echo "This is a sample test 1" > temp.txt # 写入(覆盖)：目标文件已存在，会清空后再写入当前内容
echo "This is a sample test 1" >> temp.txt # 写入(追加): 不清空原有内容

#ls + 执行异常，
ls + 2> ./error.txt
ls + >> ./error.txt  # 异常信息没有被处理
ls + 1> ./correct.txt 2>> ./error.txt # 将标准输出 与 异常输出 分别输出到各自文件中
ls + 1> ./correct.txt 2> /dev/null  # 异常信息重定向到/dev/null; 不输出，不保存
ls + 2>&1 ./correct.txt # 合并输出标准输出与异常输出

# stdout 单数据流，只能被使用到一个地方：文件 或 通过管道进入其他程序，无法两者兼得
# tee： 从stdin读取数据，然后可以将数据重定向到 stdout 或 多个文件中
  # command | tee FILE1 FILE2 | otherCommand
  # tee -a FILE 追加信息
  #  tee - 将输入内容，输出两份
  # tee 只能处理stdin内容，不能处理stderr异常信息
#ls -al | tee correct.txt | cut -c 2
#ls -al | tee -a correct.txt | cut -c 2
ls -l | tee - # 输出到-文件内





