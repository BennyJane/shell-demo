# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np

# 创建字典型series结构
d = {'Name': pd.Series(['小明', '小亮', '小红', '小华', '老赵', '小曹', '小陈',
                        '老李', '老王', '小冯', '小何', '老张']),
     'Age': pd.Series([25, 26, 25, 23, 30, 29, 23, 34, 40, 30, 51, 46]),
     'Rating': pd.Series([4.23, 3.24, 3.98, 2.56, 3.20, 4.6, 3.8, 3.78, 2.98, 4.80, 4.10, 3.65])
     }
df = pd.DataFrame(d)
print(df)

path = "F:/PythonDir/PandasDir/pandas_exercises/02_Filtering_&_Sorting/Chipotle/chipotle.csv"

# with open(path, "r", encoding="utf-8") as f:
#     for line in f:
#         print(line)


df = pd.read_csv(path, sep="\t")

print(df.head(10))
