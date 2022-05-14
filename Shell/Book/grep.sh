#!/bin/bash

# filename 可以使用正则匹配
grep 'reg' filename
grep 'reg' '*.*'
grep 'reg' $(find . -name '*.*');
grep 'reg' `ls | grep '*.sh'`;

# 一次处理多个文件
grep 'reg' file1 file2 file3

# 不匹配
grep -v 'reg' filename

# -r 递归，-E：正则 -l：只显示文件名
grep -r -E -l filename

# -n，--行号
# 在其输入文件中使用从 1 开始的行号为每行输出添加前缀。
# -n 由 POSIX 指定
grep 'reg' -n

# 递归搜索
grep 'reg' targetDir -Rn




#匹配模式选择:
# -E, --extended-regexp     扩展正则表达式egrep
# -F, --fixed-strings       一个换行符分隔的字符串的集合fgrep
# -G, --basic-regexp        基本正则
# -P, --perl-regexp         调用的perl正则
# -e, --regexp=PATTERN      后面根正则模式，默认无
# -f, --file=FILE           从文件中获得匹配模式
# -i, --ignore-case         不区分大小写
# -w, --word-regexp         匹配整个单词
# -x, --line-regexp         匹配整行
# -z, --null-data           一个 0 字节的数据行，但不是空行
#
#杂项:
# -s, --no-messages         不显示错误信息
# -v, --invert-match        显示不匹配的行
# -V, --version             显示版本号
# --help                    显示帮助信息
# --mmap                use memory-mapped input if possible
#
#输入控制:
# -m, --max-count=NUM       匹配的最大数
# -b, --byte-offset         打印匹配行前面打印该行所在的块号码。
# -n, --line-number         显示的加上匹配所在的行号
# --line-buffered           刷新输出每一行
# -H, --with-filename       当搜索多个文件时，显示匹配文件名前缀
# -h, --no-filename         当搜索多个文件时，不显示匹配文件名前缀
# --label=LABEL            print LABEL as filename for standard input
# -o, --only-matching       只显示一行中匹配PATTERN 的部分
# -q, --quiet, --silent      不显示任何东西
# --binary-files=TYPE   假定二进制文件的TYPE 类型；
#                                      TYPE 可以是`binary', `text', 或`without-match'
# -a, --text                匹配二进制的东西
# -I                        不匹配二进制的东西
# -d, --directories=ACTION  目录操作，读取，递归，跳过
# -D, --devices=ACTION      设置对设备，FIFO,管道的操作，读取，跳过
# -R, -r, --recursive       递归调用
# --include=PATTERN     只查找匹配FILE_PATTERN 的文件
# --exclude=PATTERN     跳过匹配FILE_PATTERN 的文件和目录
# --exclude-from=FILE   跳过所有除FILE 以外的文件
# -L, --files-without-match 匹配多个文件时，显示不匹配的文件名
# -l, --files-with-matches  匹配多个文件时，显示匹配的文件名
# -c, --count               显示匹配的行数
# -Z, --null                在FILE 文件最后打印空字符
#
#文件控制:
# -B, --before-context=NUM  打印匹配本身以及前面的几个行由NUM控制
# -A, --after-context=NUM   打印匹配本身以及随后的几个行由NUM控制
# -C, --context=NUM         打印匹配本身以及随后，前面的几个行由NUM控制
# -NUM                      根-C的用法一样的
# --color[=WHEN],
# --colour[=WHEN]       使用标志高亮匹配字串；
#
# -U, --binary               使用标志高亮匹配字串；
# -u, --unix-byte-offsets   当CR 字符不存在，报告字节偏移(MSDOS 模式)