# -*- coding: utf-8 -*-
import os
from typing import List

from server.constant import LogAttr


def getDirAndFilename(p: str):
    # 判断文件是否存在
    if not os.path.exists(p):
        raise Exception("文件不存在！")
    return os.path.split(p)


def get_file_size(p: str):
    # 单位为b 字节
    size_b = os.path.getsize(p)
    # size = os.stat(p).st_size
    # 将单位转换为 M
    size_m = round(size_b / 1024 / 1024, 2)
    return size_m


# -------------------------------------------------------------
# 读取大文件
# https://juejin.cn/post/6844904154037485576
# https://learnku.com/articles/54795
# -------------------------------------------------------------
def read_big_file_by_size(p: str):
    pass


def read_big_file_by_row(p: str, func=None) -> List:
    size_m = get_file_size(p)
    if size_m > LogAttr.FILE_SIZE_LIMIT:
        raise Exception("单个日志文件过大，需要分割")

    res = list()
    with open(p) as bigFile:
        for line in bigFile:
            row = func(line)
            res.append(row)
    return res


if __name__ == '__main__':
    path = "C:\\Users\\Administrator\\Downloads\\web-05-28-2020-2.log.gz"
    d, f = getDirAndFilename(path)
    print(os.path.splitext(f))

    size = get_file_size(path)
    print(size)
