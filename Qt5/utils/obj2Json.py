# -*- coding: utf-8 -*-

import json
from pprint import pprint
import execjs

"""
https://blog.csdn.net/cold___play/article/details/101777115
基于JavaScript解决下面字符串转JSON（key没有引号包裹）
"{name:'tom',age:18}"
"""

obj = "{name:'tom',age:18}"


def obj2Json(obj_str):
    with open("./JavascriptTool.js", "r", encoding="utf-8") as f:
        js_code = f.read()

    context = execjs.compile(js_code)
    result = context.call("obj2Json", obj_str)
    pprint(result)
    return result


print(obj2Json(obj))
