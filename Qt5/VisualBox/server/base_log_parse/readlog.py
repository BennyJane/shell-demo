# -*- coding: utf-8 -*-
from typing import List

from server.constant import LogAttr
from tools.os_util import get_file_size, getDirAndFilename

"""
解析日志
"""


class BaseParseLog(object):
    settings = dict()

    def __init__(self, files: List[str] = "", setting_dict=None) -> None:
        if setting_dict is None:
            setting_dict = dict()
        self.paths = files
        self.settings.update(setting_dict)

    def init_setting(self):
        self.settings = {
            LogAttr.LOG_FORMAT: "",
            LogAttr.IS_MULTI_FILE: False,
            LogAttr.IS_MERGE_BY_TIME: False,  # 是否根据时间合并多个文件
        }

    def update_setting(self, key, value):
        self.settings[key] = value

    def read_file(self):
        result = dict()
        for path in self.paths:
            try:
                dir_path, file = getDirAndFilename(path)
                log_rows = self.read_log(path)
                result[path] = log_rows
            except Exception as e:
                print(e)
        return result

    def read_log(self, file):
        size_m = get_file_size(file)
        if size_m > LogAttr.FILE_SIZE_LIMIT:
            raise Exception("单个日志文件过大，需要分割")

        filter_rows = list()
        count = 0
        with open(file) as bigFile:
            for line in bigFile:
                count += 1
                row = self.parse_row(line)
                filter_rows.append(row)
        return {
            "rows": filter_rows,
            "count": count
        }

    def parse_row(self, line: str):
        res = line
        return res
