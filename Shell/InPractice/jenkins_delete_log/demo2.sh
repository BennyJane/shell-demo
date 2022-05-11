#!/bin/bash
#### Target: 定时清空tomcat下日志文件

# -x 代码检测
set -e

#### 输入参数
percent=$1  # 磁盘预警数值,需要根据服务器磁盘大小调整输入值
tomcatPath=$2  # 服务器tomcat的路径；路径末尾不包含/


#### 整个脚本中计算文件大小的单位都使用K

#### 常量
currentDate=$(date +"%Y-%m-%d %H:%M:%S")  # 脚本执行时间
diskPath="/mnt/disk/"

# 服务器/mnt/disk挂载磁盘空间大小
diskSize=$(df -h --block-size=K ${diskPath} | tail -n 1 | awk '{print $2}' | tr -d "K")
# 预留给日志文件的上限
fileSizeLimit=$[diskSize*percent/100]
# 保留日志文件的大小，一般保留预留空间的一半
reserveFileSize=$[fileSizeLimit/2]

# tomcat日志目录
tomcatLogPath="${tomcatPath}/logs"
# 当前日志文件总大小
tomcatLogFileSize=$(du -s --block-size=K ${tomcatLogPath} | awk '{print $1}' | tr -d "K")
echo "Disk Size:         " $diskSize
echo "File Size Limit:   " $fileSizeLimit
echo "Reserve File Size: " $reserveFileSize
echo "Tomcat Log Size:   " $tomcatLogFileSize

#### 功能模块1：https://code.huawei.com/cbg_ci/VersionBuild/issues/2843
deleteLog(){
  cd $tomcatLogPath

  # 需要删除的文件大小
  needDeleteFileSize=$[tomcatLogFileSize-reserveFileSize]
  for file in `ls -tr --block-size=K`
  do
    filePath=$tomcatLogPath/$file
    fileSize=$(du --block-size=K ${filePath} | awk '{print $1}' | tr -d "K")
    echo "[Delete Tomcat Log]: " $filePath "; size: " $fileSize

    rm $filePath
    # 减去已删除的文件大小
    needDeleteFileSize=$[needDeleteFileSize-fileSize]
    if [ $needDeleteFileSize -le 0 ];then
      break
    fi
  done
}


echo "[输入参数]: ${percent} ${tomcatPath}"
echo "****************************************【begin：${currentDate}】*********************************************"
if [ ${tomcatLogFileSize} -ge ${fileSizeLimit} ]; then
  # 业务逻辑
  deleteLog
fi
echo "****************************************【end：${currentDate}】***********************************************"