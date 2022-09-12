# -*- coding: utf-8 -*-
import os
import zipfile
import gzip

from tools.os_util import getDirAndFilename

"""
参考文件
https://www.cnblogs.com/zhuminghui/p/11699313.html
"""


class DecompressFile(object):

    def __init__(self, path: str = "") -> None:
        self.path = path

    def decompress(self):
        # 判断文件是否存在
        if not os.path.exists(self.path):
            raise Exception("文件不存在！")
        if zipfile.is_zipfile(self.path):
            ZipFile(self.path).extract()
        elif self.path.endswith(".gz"):
            GzFile(self.path).extract()
        else:
            raise Exception("只支持解压zip,gz文件格式")

    def extract(self):
        raise NotImplemented


class ZipFile(DecompressFile):

    def __init__(self, path: str = None) -> None:
        super().__init__(path)

    def extract(self):
        zip_parse = zipfile.ZipFile(self.path)
        zip_files = zip_parse.namelist()

        dir_path, file = getDirAndFilename(self.path)
        filename, ext = os.path.splitext(file)
        dir_path = f"{dir_path}{os.sep}{filename}"
        for f in zip_files:
            zip_parse.extract(f, dir_path)


class GzFile(DecompressFile):

    def __init__(self, path: str = None) -> None:
        super().__init__(path)

    def extract(self):
        # 判断文件是否存在
        if not os.path.exists(self.path):
            raise Exception("文件不存在！")
        if not self.path.endswith(".gz"):
            raise Exception("请输入gz格式文件！")
        dist_dir = self.path.replace(".gz", "")
        gz_parse = gzip.GzipFile(self.path)
        # 解压文件，并写入同名目录中
        open(dist_dir, "wb+").write(gz_parse.read())
        gz_parse.close()


class RarFile(object):
    def __init__(self, path: str = None) -> None:
        super().__init__(path)

    def extract(self):
        return super().extract()


if __name__ == '__main__':
    # gz = DecompressFile("C:\\Users\\Administrator\\Downloads\\web-05-28-2020-2.log.gz")
    # gz.extract()
    z = DecompressFile("C:\\Users\\Administrator\\Downloads\\windows - 副本.zip")
    z.decompress()
