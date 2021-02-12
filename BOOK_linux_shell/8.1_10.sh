#!/bin/bash

#### 8.无网不利

##################################################### 【8.2 网络配置】  ####################################
#### ifconfig
ifconfig
# 设置网络接口的IP地址
# 以root身份运行该命令，为无线设备wlan0设置IP地址
ifconfig wlan0 192.168.0.80
ifconfig wlan0 192.168.0.80 netmask 255.255.252.0

# 动态主机配置协议(DHCP)自动为连接到网络上的计算机分配IP地址
dhclient eth0

# 打印系统可用的网络接口列表
ifconfig | cut -c-10 | tr -d ' ' | tr -s '\n'
# 显示IP地址
# ifconfig 默认显示所有活动网络接口的详细信息
# ifconfig iface_name 显示指定某个接口的信息
ifconfig wlan0
ifconfig wlan0 | egrep -o "inetaddr:[^ ]*" | grep -o "[0-9.]*"

# 硬件地址（MAC地址）欺骗
# 定义设备类别以及MAC地址，用于通过需要MAC认证才能访问Internet的情况
ifconfig eht0 hw ether 00:1c:bf:87:25:d5

# 名字服务器与DNS（域名服务）
# DNS 域名服务，将IP地址映射为符号名称
# DNS服务器：实现将域名解析为对应IP地址
# 本地网络中，设置本地DNS
cat /etc/resolv.conf                               # 查看本地名字服务器
sudo echo nameserver IP_ADDRESS >>/etc/resolv.conf # 添加新的域名与IP映射关系；或使用VIM
ping google.com                                    # 通过ping 获取指定域名对应的IP地址
# 一个域名可以对应多个IP地址，当ping方法只会显示其中一个IP地址

# DNS查找：查看域名对应的所有IP地址
host google.com     # 列出某个域名所有的IP地址
nslookup google.com # 完整列出名字与IP地址之间的相互映射；最后一行：用于DNS解析的默认名字服务器

# 在/etc/hosts文件中加入条目来实现名字解析
  # IP_ADDRESS name1 name2
  # echo IP_ADDRESS symbolic_name >>/etc/hosts
echo 192.168.0.9 backupserver >>/etc/hosts
echo 192.168.0.9 backupserver1 backupserver1 backupserver1 >>/etc/hosts

## 显示路由表信息
# 如果系统不知道如何分组到目的地的路由，则会将其发送到默认网关，默认网关可以连接到Internet或部门内部的路由器
route # 默认IP显示为映射的名称
route -n  # 使用数字显示IP地址
route add default gw IP_ADDRESS INTERFACE_NAME  # 添加默认网关
route add default gw 192.168.0.1 wlan0

##################################################### 【8.3 ping】  ###################################################
#### ping： 检查网络上主机之间的连通性，找到活动主机
# ping IP_ADDRESS 域名或IP
# 通过对网络设备(如 路由器)配置，使其不响应ping命令。降低安全风险，因为ping可以被攻击者(使用蛮力)用来获取主机的IP地址
ping 192.168.0.1
# rtt（Round Trip Time） 每个分组的往返时间，单位毫秒
# rtt 四个值： 最小时间/平均时间/最大时间/平均偏差
# seq 序列号，从1开始； 如果网络接近饱和，分组可能会因为冲突、重试或被丢弃的原因，以乱序的形式返回
# ttl (TimeTo Live)生存时间, 表明发出ping命令的主机和目的主机相隔多少个路由器； 该值一般都有固定的默认值，在分组路径中每个路由器都会将该值减1，
# -c COUNT 限制发送分组的数量
ping 127.0.0.1  # ping 回环地址，确定ttl的初始值
ping www.google.com # 使用ttl默认值-返回的ttl值，获取两个位置之间的跳数
# ping 命令执行顺序，返回状态为0，否则返回，非0

##################################################### 【8.4 跟踪IP路由】  ################################################
#### traceroute 显示分组途径的所有网关地址，有助于理清分组到达目的地需要经过多少跳
traceroute destinationIP
mtr destinationIP # 实时刷新数据

##################################################### 【8.4 列出网络中所有的活动主机】  ####################################
####


##################################################### 【8.10 实现SSH的无密码自动登录】  ###################################
#### SSH采用的非对称加密
# 参考文章 https://www.cnblogs.com/gaoBlog/p/11619917.html

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N password -C comment
# -t 密钥类型： dsa|ecdsa|ed25519|rsa; 省略情况下，默认为rsa
# -f 密钥目录位置，指定密钥的保存路径和文件名。默认为当前用户home路径下的.ssh隐藏目录，文件名id_rsa
# -N 指定密钥对的密码，指定该参数，则后续不会再出现输入密码的交互；如果设置了密码，后续每次都需要输入密码
# 一般不设置密码
# -C 密钥的备注信息，会出现再生成的公钥的最后面

## 常用操作
ssh-keygen -t rsa
#  Generating public/private rsa key pair.
#  Enter file in which to save the key (/home/fdipzone/.ssh/id_rsa): 这里输入要生成的文件名
#  Enter passphrase (empty for no passphrase):                       这里输入密码
#  Enter same passphrase again:                                      这里重复输入密码
#  Your identification has been saved in /home/fdipzone/.ssh/id_rsa.
#  Your public key has been saved in /home/fdipzone/.ssh/id_rsa.pub.
#  The key fingerprint is:
#  f2:76:c3:6b:26:10:14:fc:43:e0:0c:4d:51:c9:a2:b0 fdipzone@ubuntu
#  The key's randomart image is:
#  +--[ RSA 2048]----+
#  |    .+=*..       |
#  |  .  += +        |
#  |   o oo+         |
#  |  E . . o        |
#  |      ..S.       |
#  |      .o .       |
#  |       .o +      |
#  |       ...oo     |
#  |         +.      |
#  +-----------------+

ssh-keygen -t rsa -P "" # 免密码

## 将公钥复制到免密码登录的目标服务器上（在客户端主机上，将id_rsa.pub添加到相应的authorized_keys中，可实现免密码登录自身）
# 1. 在目标服务器上操作
scp client@localhost:/home/client/.ssh/id_rsa.pub /home/server
cat /home/server/id_rsa.pub >>.ssh/authorized_keys # 将公钥添加到文件末尾，允许添加多个公钥
rm /home/server/id_rsa.pub                         # 删除复制过来的源文件

# 2.在客户端主机上使用 ssh-copy-id
ssh-copy-id target@IP

## 检测ssh密钥是否生效
ssh localhost
# ssh -l [用户名] [远程IP]
ssh -l benny 119.56.23.1

## ssh 客户端 服务器端安装
sudo apt-get upgrade
sudo apt-get install openssh-server # 服务端安装
sudo apt-get install openssh-client # 客户端安装

## 配置/etc/hosts中 主机名与IP地址，可以直接使用 ssh [主机名] 登录，不需要输入IP

# https://segmentfault.com/a/1190000015362485
