## jenkins日志删除脚本逻辑分析

jenkins master机器日志清理优化
当前jenkins master机器存在日志激增的情况，热别是芯片组件构建

需要将tomca t日志（cataline.out）纳入清理任务中

另外，需要优化当前的日志清理机制，考虑时间和日志目录大小，两个维度

# 服务器上Jenkins构建文件分析
以服务器(10.162.51.28)为分析对象，数据获取日期：2021-02-04。

#### 当前磁盘使用情况 `df -h /mnt/disk`

```shell
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvde1      2.0T  1.2T  714G  63% /mnt/disk
```
#### Jenkins内job下文件总大小 `du -sh /mnt/disk/jmaster1/.jenkins/jobs`
```shell
1.1T    /mnt/disk/jmaster1/.jenkins/jobs
```
#### `chipset_pipeline_release` 模块下文件总大小
 `du -sh /mnt/disk/jmaster1/.jenkins/jobs/chipset_pipeline_release`  
```shell
# 大部分内存都被芯片组件占用
909G    /mnt/disk/jmaster1/.jenkins/jobs/chipset_pipeline_release/
```
#### `chipset_pipeline_release` 模块下文件按天分布情况
`export TIME_STYLE="+%Y-%m-%d"`  
`ls -ldt [0-9]* | awk '{print $6}' | uniq -c`
```shell
文件数量  日期 
     38 2021-02-04
     60 2021-02-03
     53 2021-02-02
     63 2021-02-01
     45 2021-01-31
     55 2021-01-30
     56 2021-01-29
     56 2021-01-28
     70 2021-01-27
     77 2021-01-26
     83 2021-01-25
     58 2021-01-24
     60 2021-01-23
     80 2021-01-22
     94 2021-01-21
    113 2021-01-20
     93 2021-01-19
     66 2021-01-18
     54 2021-01-17
     68 2021-01-16
     77 2021-01-15
    129 2021-01-14
     74 2021-01-13
     88 2021-01-12
     57 2021-01-11
     62 2021-01-10
     71 2021-01-09
     61 2021-01-08
     68 2021-01-07
     77 2021-01-06
     56 2021-01-05
     69 2021-01-04
     53 2021-01-03
     55 2021-01-02
     66 2021-01-01
     70 2020-12-31
     70 2020-12-30
     85 2020-12-29
     74 2020-12-28
     61 2020-12-27
     67 2020-12-26
     71 2020-12-25
     62 2020-12-24
      2 2020-12-23
```
从2020-12-23到2021-02-04，总共44天，`平均每天使用内存约20G左右(909G / 44天)`；  
单日构建次数最多：129次（2021-01-14），当天构建文件大小最大值 4153612  
单日构建次数最少: 2次 (2020-12-23), 应该被删除过。  
`du --max-depth=1 . | sort -nrk 1`  
单个构建文件最大：12825804 12798(目录序号)  
单个构建文件最小：668 13077  
34个文件超过10G  


**当前`chipset_pipeline_release` 下总文件数量 2996 （下一次删除20%的文件，删除数量约 600，删除天数大约10天），最后保留最近35天左右的构建文件**



#### `chipset_pipeline_release` 模块下任意一天构建文件大小分布（修改-mtime 的值）
`find .  -maxdepth 1 -mtime 1 -exec du -sh {}  \;`
该命令用于显示指定日期下文件大小详细情况

#### 单个构建文件内部，内存分布情况 `ls -S`
```shell
total 12807352
-rw-rw-r--    1 jmaster1 jmaster1 12379053417 2021-01-28 log
-rw-rw-r--    1 jmaster1 jmaster1   734219853 2021-01-28 log-index
-rw-rw-r--    1 jmaster1 jmaster1      296175 2021-01-28 build.xml
drwxrwxr-x    2 jmaster1 jmaster1      131072 2021-01-28 workflow/
```
当构建文件非常大时，往往都是log 以及 log-index文件非常大，这两个文件主要用于jenkins界面上Console Output的显示；可以考虑清空内容(不直接删除)  
参考案例：  
12455 构建目录下log log-index 仅内容被清空的效果  
http://100.104.178.202:8080/jenkins/job/chipset_pipeline_release/12455/flowGraphTable/


#### 统计各个jobs下保留的构建文件的时间跨度
```shell
#!/bin/bash

#### 常量
jobsPath=/mnt/disk/jmaster1/.jenkins/jobs


declare -A statarray;

export TIME_STYLE='+%Y-%m-%d'

for dir in `ls $jobsPath`
do
  cd $jobsPath/$dir/builds 
  dayNum=$(ls -ldt [0-9]* | awk '{print $6}' | uniq -c | wc -l)
  let statarray["$dir"]=$dayNum;
done

for dirname in "${!statarray[@]}";
do 
  printf "%-50s  %10s \n" $dirname ${statarray[$dirname]}
done

```
统计结果: 目录名称 构建文件日期跨度(天)
```shell
test_pipeline_release                                       48
solution_package_pipeline_release                           47
hota_package_pipeline_release                               46
custom_package_pipeline_release                             46
system_pipeline_release                                     45
version_pipeline_release                                    44
mbb_product_build                                           44
chipset_pipeline_release                                    44
product_pipeline_release                                    43
preavs_pipeline_release                                     43
preas_pipeline_release                                      43
module_update_compile                                       43
cust_pipeline_release                                       43
preload_package_pipeline_release                            42
mbb_make_repo_tag                                           42
prets_pipeline_release                                      41
cota_package_for_build_service                              38
zidane_system_pipeline_release                              37
base_package_upload_vmp                                     37
base_package_pipeline_release                               37
modem_pipeline_release                                      35
base_package_tag_patch_trigger                              34
custom_package_upload_vmp                                   30
common_component_tag_patch_trigger                          27
pretvs_pipeline_release                                     22
preload_package_upload_vmp                                  21
module_update_archive                                       16
upload_tag_pipeline_job                                     14
cota_package_upload_vmp                                     13
native_cold_patch                                           10
patch_package                                                9
UOS_System_Trunk_Build_Trigger                               8
module_update_train                                          7
framework_cold_patch                                         7
apk_hot_patch                                                7
UOS_Module_Build_Trigger                                     6
compile_EMUI11.0_HISI_GMS_Dnal                               6
common_package_tag_patch_trigger                             6
kernel_cold_patch                                            2
sensorhub_cold_patch                                         1
security_patch_pack_static_build                             1
patch_package_archive_productionline                         1
nv_cold_patch                                                1
framework_hot_patch                                          1
cota_package_for_build_service_old                           1
ApplyAgenttest_hpp                                           1
patch_package_upload_vmp                                     0
modem_patch                                                  0
modem_cold_patch                                             0

```

## 日志清理优化策略
- 保留原有逻辑：每次删除构建文件总数目的20%，增加对芯片组件构建文件的单独处理方法：`将25或30天前大于1G的构建文件下的log log-index文件清空(非删除)`；   
其他构建组件的文件时间跨度不一致，且少有单个构建文件超1G的情况，上述逻辑不太适合其他组件。  
其他构建组件占内存比例不大，清理收益不明显，而且会增加脚本执行时间。

- 应对当日内存激增的问题：内存激增大概率来自tomcat日志激增，单独设置定时任务，每N分钟检测一次，系统磁盘占用是否超过限制，触发删除操作，提高删除的频率。  
内存激增造成服务器空间不足后，需要及时清理，等待凌晨3点的定时任务清理，可能会造成服务器较长时间无法正常工作，或仍然需要人工处理。


## 脚本实现与测试
新增脚本仍然放在服务器目录`/mnt/disk/schedule` 下：  
- `delJenkinsFile.sh`  负责jenkins文件清理
- `delLogOfTomcat.sh` 负责tomcat日志清理

定时任务：
```shell
0 3 * * * /bin/sh /mnt/disk/schedule/delJenkinsFile.sh 70 /mnt/disk/jmaster1 20 25 >>/mnt/disk/schedule/jenkins_del.log 2>&1
10 */1 * * * /bin/sh /mnt/disk/schedule/delLogOfTomcat.sh 70 /mnt/disk/jmaster1/server/apache-tomcat-6.0.28  >> /mnt/disk/schedule/tomcat_del.log 2>&1
```

执行结果：
```text
10.162.51.28
0207: 
    12:20执行jenkins定时清理任务, 参数设置 68 /mnt/disk/jmaster1 20 25
    # 清理前： /dev/xvde1      2.0T  1.3T  617G  68% /mnt/disk
    # 清理后： /dev/xvde1      2.0T  904G 1010G  48% /mnt/disk
    # 总结：总计清理约400G文件，删除清空文件约5500个
    
    13：10执行tomcat定时清理任务, 参数设置 45 
    # 清理前： 日志文件数量 175 大小 7.8G
    # 清理后： 36k

10.187.36.199   达到70%
0207: 
    15：10执行tomcat定时清理任务, 参数设置 70
    # 清理后： /dev/xvde1      2.0T  1.2T  782G  60% /mnt/disk
```
