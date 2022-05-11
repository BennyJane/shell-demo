#!/bin/bash
# Target: 定时清理jenkins构建文件

# -x 代码检测
set -e

#### 输入参数
percent=$1  # 内存预警百分比
jenkinsPath=$2  # 当前服务器jenkins路径
deletePercent=$3  # 指定删除的文件总数目百分比
beforeDays=$4 # 指定删除N天前的构建文件的日志

#### 常量
diskPath="/mnt/disk/"
dayLimit=25 # 限制N天内构建文件不可删除，避免参数配置错误导致过量删除
fileSizeLimit=1024  # 被删除构建文件大小最小值： du单位k
currentDate=$(date +"%Y-%m-%d %H:%M:%S")


#### 磁盘内存使用率
diskUsedPercent=$(df -h ${diskPath} | tail -n 1 | awk '{print $5}' | tr -d "%")


#### jenkins 构建历史清理: 针对所有job目录
deletedFileOfJenkins() {
  jobPath="${jenkinsPath}/.jenkins/jobs"
  for jobName in `ls ${jobPath}` # 遍历jobs目录下所有目录
  do
    buildPath="${jobPath}/${jobName}/builds"
    cd $buildPath  # 切换目录

    folderNum=`ls -l | grep "^d" | wc -l`
    deletedNum=$[folderNum*deletePercent/100] # 整数计算
    if [ $deletedNum -ge 5 ]; then
      printf "[JobName]: %-80s [BuildNum]: %-10s [DeletedNum]: %-10s \n" ${jobName} ${folderNum} ${deletedNum}
      for buildNum in `find . -maxdepth 1 -name "[0-9]*" | tr -d ".\/" | sort -n | head -n $deletedNum`
      do
        targetFilePath=$buildPath/$buildNum
        echo "[DeleteDir]: ${targetFilePath}"
        # 执行文件删除
        rm -rf "${targetFilePath}"
      done
    fi
  done
}

#### 指定构建组件清理
deletedSpecialPipeline() {
  targetPipeline=$1
  daysAgo=$2
  oneFileSize=$3

  jobPath="${jenkinsPath}/.jenkins/jobs/${targetPipeline}/builds"
  cd $jobPath
  # 检测输入值范围, 避免参数配置不正确导致文件被过量删除
  if [ $daysAgo -ge $dayLimit ] && [ $oneFileSize -ge $fileSizeLimit ]; then
    for file in `find . -maxdepth 1 -type d -mtime +${daysAgo} | tr -d './'`
    do
      fileSize=`du -s ${file} | awk '{print $1}'`  # 默认单位为K
      if [ $fileSize -gt $oneFileSize ]; then
        filePath="${jobPath}/${file}"
        echo "[CleanLog]: ${filePath} ${fileSize}"
        # 清空日志文件
        echo > "${filePath}/log"
        echo > "${filePath}/log-index"
      fi
    done
  fi

}

echo "预警指数: ${percent};  路径：${jenkinsPath};  保留数量：${deletePercent}"
echo "****************************************【begin：${currentDate}】*********************************************"
if [ ${diskUsedPercent} -ge ${percent} ]; then
  # 业务逻辑
  deletedFileOfJenkins
  deletedSpecialPipeline "chipset_pipeline_release" ${beforeDays} 1048576  # 1024*1024

fi
echo "****************************************【end：${currentDate}】*********************************************"