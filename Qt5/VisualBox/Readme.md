
### 打包发布

```shell
pyinstaller -F -w main.py
pyinstaller -F -w -i icon.ico main.py

# -w 无命令提示框打包方式; 删除-w打包后，启动exe文件，会显示后台执行cmd，可用于查看运行日志
pyinstaller -w --onefile main.py

pyinstaller -D --add-data=".\widget_gallery\svg\*.svg;.\widget_gallery\svg" main.py

# 打包单个exe文件，并包含图标文件
pyinstaller -F -w --onefile --add-data=".\widget_gallery\svg\*.svg;.\widget_gallery\svg" -i VisualBox.ico --name="VisualBox" main.py
pyinstaller -F --onefile --add-data=".\widget_gallery\svg\*.svg;.\widget_gallery\svg" --add-data=".\VisualBox.ico;." -i VisualBox.ico main.py


# 基于spec配置文件打包
pyinstaller main.spec
```

