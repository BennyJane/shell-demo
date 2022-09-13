
### 打包发布

```shell
# -w 无命令提示框打包方式; 删除-w打包后，启动exe文件，会显示后台执行cmd，可用于查看运行日志
pyinstaller -w --onefile main.py
pyinstaller -D --add-data=".\gallery\svg\*.svg;.\gallery\svg" main.py

# 日志解析小功能
pyinstaller -F -w --onefile --add-data=".\gallery\svg\*.svg;.\gallery\svg"  -i VisualBox.ico --name="VisualBox" main.py


# 基于spec配置文件打包
pyinstaller VisualBox.spec
```
## 功能规划
- [ ]提示版本更新

### JSON解析
- [ ] 日志解析下面三个功能按钮：按钮增大、间隔增大
- [ ] 解析后JSON数据，需要支持折叠功能，最好可以缩放

### log检索: 参考NotePad++
```markdown
考虑不同使用场景
- 基于行号搜索
- 时间范围搜索
- 基于匹配搜索（二级搜索）

```
- [ ] 跳转指定行数，查询指定范围上下文
- [ ] 搜索：时间范围搜索
- [ ] 搜索：正则、指定关键词
- [ ] 超大文件，分页显示
- [ ] 关键日志文件复制