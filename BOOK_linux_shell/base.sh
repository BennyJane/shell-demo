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