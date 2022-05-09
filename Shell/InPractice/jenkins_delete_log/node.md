## 日志删除脚本
jenkins_statistical.sh
```
#!/bin/bash

set -e

jenkins_build_path="/mnt/disk/jmaster1/.jenkins/jobs"
cd $jenkins_build_path

for dirName in `ls -tr`
do
    # echo $dirName
    childDir="${jenkins_build_path}/${dirName}/builds/"
    build_size=`du -sh ${childDir} | awk '{print $1}' | head`
    # echo "${build_size}"

    build_file_total=`ls ${childDir} | wc -l`

    next_file="${jenkins_build_path}/${dirName}/nextBuildNumber"
    next_number=`cat $next_file | head -n 1`


    printf "%-50s %5s %5s %5s \n" $dirName $next_number $build_size $build_file_total
done

```

```
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

```


## 优化
jenkins master机器tomcat系统日志清理需要优化，避免过度清理，关键日志丢失
tomcat日志判断条件需要修改：查询/mnt/disk/jmaster1/server/apache-tomcat-6.0.28/logs/目录下文件大小，判断是否超过上限阈值：/mnt/disk目录大小的10%（一般master机器/mnt/disk磁盘大小为2T，则上限阈值为2T * 10% = 100G）
如果超过上限阈值，则清理/mnt/disk/jmaster1/server/apache-tomcat-6.0.28/logs目录日志，清理到正常阈值：/mnt/disk磁盘占用的5%（即50G）
清理策略：将/mnt/disk/jmaster1/server/apache-tomcat-6.0.28/logs下日志文件按日期从旧到新排序，然后开始清理，达到正常阈值则清理完成
对于磁盘空间较小的master（如：10.29.141.176），可相应调高上限阈值，比如20%；以及正常阈值，比如10%

```
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

```
