# -*- coding: utf-8 -*-




class LogRow(object):
    __slots__ = ('info',)

    fields = ["time", "level", "content", "desc"]

    def __init__(self) -> None:
        self.info = {k: "" for k in self.fields}
