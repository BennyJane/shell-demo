# !/usr/bin/env python
# -*-coding:utf-8 -*-
# Warning    ：The Hard Way Is Easier

import os
import shutil
import codecs

# https://blog.csdn.net/ITerated/article/details/110001345


# Python脚本自动清理，判断该项目是否已经构建了60次以上，保留最近50次构建。

jobs_path = "/home/jenkins/jobs"

for dirname in os.listdir(jobs_path):
    next_path = jobs_path + "/%s/nextBuildNumber" % dirname  # nextBuildNumber文本内容为下一次构建序号，每个job下都有这个文件
    if os.path.exists(next_path):
        print(next_path)
        next_build_no = int(codecs.open(next_path).read())
        print(dirname, next_build_no)
        if next_build_no > 60:  # 判断该项目是否已经构建了60次以上
            for i in range(next_build_no - 50, 1, -1):  # 保留最近50次构建
                job_path = jobs_path + "/%s/builds/%s" % (dirname, i)
                if os.path.exists(job_path):
                    print("delete " + job_path)
                    shutil.rmtree(job_path)
