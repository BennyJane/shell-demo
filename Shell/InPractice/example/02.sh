#!/bin/bash

#############################################
#        异步压缩zip文件
#############################################
#!/bin/bash
set -e
## 脚本文件

# 压缩文件夹(不需要拆分)
zip -q -r ${COMPRESS_PATH}/${version}_BiddingDoc.zip $Path/BiddingDoc/ &
zip -q -r ${COMPRESS_PATH}/${version}_root.zip $Path/root/ &

# 压缩Fastboot包: 排除U盘包文件
zip -q -r ${COMPRESS_PATH}/${version}_Fastboot-odex.zip $Path/odex -x "*dload*" &
zip -q -r ${COMPRESS_PATH}/${version}_Fastboot-nolog.zip $Path/no_log -x "*dload*" &
zip -q -r ${COMPRESS_PATH}/${version}_Fastboot-dex.zip $Path/dex -x "*dload*" &

# 压缩U盘包
zip -q -r ${COMPRESS_PATH}/${version}_U-dex.zip $Path/dex/dload &
zip -q -r ${COMPRESS_PATH}/${version}_U-odex.zip $Path/odex/dload &
zip -q -r ${COMPRESS_PATH}/${version}_U-nolog.zip $Path/no_log/dload &


# 文件类型：直接压缩
for file in `ls ${Path}`
do
  file_path=$Path/$file
  if [ -f ${file_path} ]; then
     echo $file_path
     zip -q ${COMPRESS_PATH}/${file}.zip ${file_path}
     #cp ${file_path} $COMPRESS_PATH
  fi
done

# 判断后台zip进程的数量，如果进程数大于0，睡眠1分钟后再次检测
processNum=1
while [ $processNum -gt 0 ]
do
  processNum=`ps -ef | grep zip | grep -v grep | wc -l`
  sleep 60s
done


#############################################
#        重启Grafana的mongoDB插件
#############################################
#!/bin/bash
#### Target: 定时重启项目

set -e

#### 脚本使用方法
# 服务器创建脚本文件： touch restart_server.sh ; chmod 766 restart_server.sh;
# 执行测试: ./restart_server.sh
# 添加定时任务: crontab -e
# 查看定时任务: crontab -l



#### 常量
currentDate=$(date +"%Y%m%d")  # 脚本执行时间
numLimit=1024
serverPath=/mnt/disk/emui9x_service/langfang/10.253.56.149/100.126.214.53/9.x/sync-mqinformation/perforce-version-sync-mqinformation09
newLogName="mq09_${currentDate}.log"

#### 检测是否需要重启服务
main() {
  currentPid=`ps -ef |grep perforce-version-sync-mqinformation09-1.0-SNAPSHOT.jar | grep -v "grep" | awk '{print $2}'`
  # 考虑进程ID为空的情况？
  busyFileNum=`lsof -p ${currentPid} | wc -l`
  echo "[busyFileNum]: ${busyFileNum}; [currentPid]: ${currentPid}"
  if [ ${busyFileNum} > ${numLimit} ]; then

    kill -9 $currentPid
    cd  $serverPath
    nohup java -jar perforce-version-sync-mqinformation09-1.0-SNAPSHOT.jar > $newLogName 2>&1
  fi
}


echo "[输入参数]: "
echo "****************************************【begin：${currentDate}】*********************************************"
# 业务逻辑
main

echo "****************************************【end：${currentDate}】***********************************************"


