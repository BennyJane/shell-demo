#!/bin/bash

# 不匹配
grep -v 'reg'

grep 'reg' file1 file2 file3

# 显示文件名、行号等信息
grep 'reg' -n
grep 'reg' -n 1
grep 'reg' -n 2