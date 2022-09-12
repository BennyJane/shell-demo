# -*- coding: utf-8 -*-

# -------------------------------------------------------------
# 日志解析参数
# -------------------------------------------------------------
class LogAttr(object):
    LOG_FORMAT = ""
    # 是否为多个文件
    IS_MULTI_FILE = False
    # 是否根据时间合并多个文件
    IS_MERGE_BY_TIME = False
    # 当单个文件大于1G时，可以考拉将文件划分为多个小文件
    FILE_SIZE_LIMIT = 1024
    # 当日志文件过大时，每200M划分为一个小文件
    SPLIT_LOG_SIZE = 200

    ATTR_KEYS = tuple(locals().keys())


if __name__ == '__main__':
    LogAttr()
