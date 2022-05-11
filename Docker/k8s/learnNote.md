K8s

# 常用命令

## TIPS

- [x] `|` 符号 表示该位置两个字母均可以使用
- [x] `<value>` 表示需要填入相应的变量

## 帮助文档

```shell
# 查看支持的命令
kubectl --help|-h
# 查看具体命令的帮助文档
# 查看get命令的文档，可以看到各个资源类型的缩写
kubectl get --help|-h
kubectl get api-resources
kubectl get rollout

kubectl explain rs: 显示资源对象文档信息，配置信息
# 查看配置文档
kubectl explain deployment
kubectl explain deployment.spec
kubectl explain deployment.spec.replicas
```

## 查看信息

```shell
# 节点信息
kubectl get nodes
kubectl get no

# 集群信息
kubectl cluster-info

# 列出所有资源信息
kubectl get all
kubectl get all -n <namespace>
kubectl get pod --all-namespaces
kubectl get pod -a	# 显示终止状态的pod，默认不显示

# 命名空间
kubectl get ns|namespace

# Deployment
kubectl get deploy|deployment

# 服务Service
kubectl get service|services|svc

# pod信息
kubectl get pods|pod|po

# 查询标签信息
kubectl get <source-type> --show-labels
kubectl get pod --show-lables

# 通过标签查询,支持： = == !=
kubectl get pod -l|--selector <key>=<value>,<key1>=<value1>
kb get pod --selector release=alpha

# 查看某个资源的详细信息：no ns deploy svc po
kubectl get pods -o wide|json|yaml
kubectl describe pod
kubectl get -o json pod <pod-name>	# 只显示指定pod信息
kubectl get pod --namespace <namespace-name>
kubectl get pod --show-labels

# 将信息导出,然后再创建
kubectl get po -o yaml > /temp/<filename>.yaml
kubectl get po -o json > /temp/<filename>.json
```

## 创建删除

```shell
# 利用yaml文件创建、删除、更新对象
kubectl create -f <filename>|<path/filename>
kubectl delete -f <filename>|<path/filename>
kubectl apply -f <filename>|<path/filename>
# 强制更新
kubectl replace --force -f <filename>|<path/filename>

# run 在集群中创建并运行一个或多个容器
# run NAME --image=image [--env="key=value"] [--port=port] [--replicas=replicas] [--dry-run=bool] [--overrides=inline-json] [--command] -- [COMMAND] [args...]
# 示例，运行一个名称为nginx，副本数为3，标签为app=example，镜像为nginx:1.10，端口为80的容器实例
kubectl run nginx --replicas=3 --labels="app=example" --image=nginx:1.1 -port=80

# 创建命令空间
kubectl create ns <namespace-name>
# ！！！会异步删除命名空间下的所有资源
kubeclt delete ns <namespace-name>
```

## 更新编辑

优先推荐通过修改`yaml`文件来实现更新操作

```shell
# !!! 三个属性：apiVersion, kind and name，一旦创建，不能被修改，除非删除或重建

# set

# edit： 
kubectl edit <source-type> <source-name>
# 空格 或 / 都可以
kubectl edit service nginx
kubectl edit service/nginx
```

## 标记注释

```shell
# label


# annotate



# completion

```



## 日志与进入容器

```shell
# 查看pod日志
# pod内只有一个容器
kubectl log|logs <pod-name>
kubectl log <pod-name> -c <container-name>
kubectl log <pod-name> --containwe=<container-name>

kubectl logs --tail=20 nginx
kubectl logs --since=1h nginx
# streaming 类型的日志输出
kubectl logs -f -c ruby web-1
kubectl logs --since=1h nginx

# 进入pod内容器内部; 退出命令 exit
kubectl exec -it <pod-name> -n <namespace> bash
# 在Pod(容器)中执行命令
kubectl exec <pod-name> env|<cmd>

# 暴露端口,作为一个Service服务使用
kubectl expose deployment

```

## 版本更新与回退

```shell
# 使用set edit 编辑信息
kubectl set image deploy <deploy-name> conatiner_name=<new_image_name>
# 查询历史版本, 可以看到更新的操作
kubectl rollout history deploy <deploy-name>
# 回退版本
kubectl rollout undo deploy <deploy-name>
# rollout 命令

```

## expose：暴露端口

`kubectl expose` 该命令会创建一个Service类型的资源

```shell
# 基于Deployment类型资源，创建一个类型为NodePort，暴露容器端口8080的Service
kubectl expose deployment/<pod-name> --type="NodePort" --port 8080
# 查看执行结果
kubectl get service

# help信息
# Possible resources include (case insensitive): pod (po), service (svc), replicationcontroller (rc), deployment (deploy), replicaset (rs)
# Examples:
  # Create a service for a replicated nginx, which serves on port 80 and connects to the containers on port 8000.
  kubectl expose rc nginx --port=80 --target-port=8000

  # Create a service for a replication controller identified by type and name specified in "nginx-controller.yaml", which serves on port 80 and connects to the containers on port 8000.
  kubectl expose -f nginx-controller.yaml --port=80 --target-port=8000

  # Create a service for a pod valid-pod, which serves on port 444 with the name "frontend"
  kubectl expose pod valid-pod --port=444 --name=frontend

  # Create a second service based on the above service, exposing the container port 8443 as port 443 with the name "nginx-https"
  kubectl expose service nginx --port=443 --target-port=8443 --name=nginx-https

  # Create a service for a replicated streaming application on port 4100 balancing UDP traffic and named 'video-stream'.
  kubectl expose rc streamer --port=4100 --protocol=udp --name=video-stream

  # Create a service for a replicated nginx using replica set, which serves on port 80 and connects to the containers on port 8000.
  kubectl expose rs nginx --port=80 --target-port=8000

  # Create a service for an nginx deployment, which serves on port 80 and connects to the containers on port 8000.
  kubectl expose deployment nginx --port=80 --target-port=8000
```

# 日常维护

## Pod(容器)异常分析

```shell
# pod创建、启动异常
kubectl describe pod <pod-name>
"""
CrashLoopBackOff： 容器退出，kubelet正在将它重启
InvalidImageName： 无法解析镜像名称
ImageInspectError： 无法校验镜像
ErrImageNeverPull： 策略禁止拉取镜像
ImagePullBackOff： 正在重试拉取
RegistryUnavailable： 连接不到镜像中心
ErrImagePull： 通用的拉取镜像出错
CreateContainerConfigError： 不能创建kubelet使用的容器配置
CreateContainerError： 创建容器失败
m.internalLifecycle.PreStartContainer 执行hook报错
RunContainerError： 启动容器失败
PostStartHookError： 执行hook报错
ContainersNotInitialized： 容器没有初始化完毕
ContainersNotReady： 容器没有准备完毕
ContainerCreating：容器创建中
PodInitializing：pod 初始化中
DockerDaemonNotReady：docker还没有完全启动
NetworkPluginNotReady： 网络插件还没有完全启动
"""

# 运行过程中日志
kubectl logs <pod-name>
# pod内存在多个容器，需要先使用describe查询具体容器名称
kubectl logs <pod-name> -c <container>

# 系统日志
# 在Pod所在的Node节点上查看系统日志，
journalctl -f -u kubelet
journalctl -xeu kube-controller-manager --no-pager
journalctl -xeu kube-scheduler --no-pager
journalctl -xeu kubelet --no-pager

-u表示筛选指定标签，此处为kubelet
-f表示跟踪日志
-x表示增加信息解释
-e表示立刻跳转至页面底部
–no-pager表示不将程序的输出内容管道(pipe)给分页程序

# 查看主机日志
tailf /var/log/messages	# Centos
tailf /var/log/system	# ubuntu
```



## 更新镜像|版本回退

手动实现升级 或 版本回退

```shell

```

## 重启Pod

```shell
# 1.有yaml文件
kubectl replace --force -f <name>.yaml
# 2. 没有yaml，但可以使用Deployment对象；
	# 由于 Deployment 对象并不是直接操控的 Pod 对象，而是操控的 ReplicaSet 对象，而 ReplicaSet 对象就是由副本的数目的定义和Pod 模板组成的。所以这条命令分别是将ReplicaSet 的数量 scale 到 0，然后又 scale 到 1，那么 Pod 也就重启了
# 先关闭为0
kubectl scale deployment <deployName> --replicas=0 -n <namespace>	
# 再重启
kubectl scale deployment <deployName> --replicas=1 -n <namespace>	

# 3.直接删除Pod重启：要求Pod配置重启策略
kubectl delete pod <podname> -n <namespace>	# 直接删除命令空间下的pod, 逐个删除
kubectl delete replicaset <rs_name> -n <namespace>	# 直接删除ReplicaSet，管理的多个Pod也被删除

# 先导出Pod模板，再重建Pod
	# 在这种情况下，由于没有 yaml 文件，且启动的是 Pod 对象，那么是无法直接删除或者 scale 到 0 的，但可以通过上面这条命令重启。这条命令的意思是 get 当前运行的 pod 的 yaml声明，并管道重定向输出到 kubectl replace命令的标准输入，从而达到重启的目的
	# 适用于没有Deployment
kubectl get pod <podName> -n <namespace> -o yaml | replace --force -f -

# Kubernetes 1.15开始才有，重启Pod
kubectl rollout restart deploy <deploymentName>


## 删除Pod
# 直接删除Pod，触发replicaSet保护机制，还是会重启Pod，应该直接删除deployment
kubectl delete deployment <podName>
```



# 补充内容

## k8s管理操作优化

```shell
# 利用linux的 alias 配置kubectl命令缩写
vim ~/.bashrc
#添加内容：alias kb='kubectl'
source ~/.bashrc

# 安装 kubectx kubens 快速切换默认的集群、默认的命令空间
# https://github.com/ahmetb/kubectx/tree/v0.9.4
# 可以本地下载，再上传到服务器
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
# 建立软链接
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# kubectx 使用方法
USAGE:
  kubectx                   : list the contexts
  kubectx <NAME>            : switch to context <NAME>
  kubectx -                 : switch to the previous context
  kubectx -c, --current     : show the current context name
  kubectx <NEW_NAME>=<NAME> : rename context <NAME> to <NEW_NAME>
  kubectx <NEW_NAME>=.      : rename current-context to <NEW_NAME>
  kubectx -d <NAME>         : delete context <NAME> ('.' for current-context)
                              (this command won't delete the user/cluster entry
                              that is used by the context)
  kubectx -u, --unset       : unset the current context
 
 # kubens 使用方法
USAGE:
  kubens                    : list the namespaces
  kubens <NAME>             : change the active namespace
  kubens -                  : switch to the previous namespace
  kubens -c, --current      : show the current namespace
```

# 参考资料

专题类型

https://www.cnblogs.com/cocowool/p/k8s_describe_node_pod_and_service.html

局部内容

