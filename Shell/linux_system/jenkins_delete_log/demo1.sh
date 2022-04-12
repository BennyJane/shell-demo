#!/bin/bash

##################################################### 【定时删除服务器日志】  ############################################

#### find /path -mtime +num -name ".log" -exec rm -rf {} \;
  # 查找指定目录下num天前产生的日志文件，并删除
  # -mtime 文件修改时间,默认单位 天； +30 30天以前生成的日志,-30 30内 30 距今恰好30天的那天的日志
  # ".log" .匹配符号，查找末尾为log的文件
  # -exec find的固定写法，针对查找结果执行后续的命令,此处执行rm删除命令
find /opt/soft/log/ -mtime +10 -name ".log" -exec rm -rf {} \;

#### 一般都需要给shell文件添加可执行权限
chomd a+x target.sh

#### 计划任务:
  # crontab -l 查看当前系统的定时任务
  # crontab -e 编辑当前系统的定时任务
  # 10 0 * * * /opt/soft/auto_del_30_days_ago_log.sh > /dev/null 2>&1



