#!/bin/bash

#### 8.无网不利

##################################################### 【8.10 实现SSH的无密码自动登录】  ####################################
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
cat /home/server/id_rsa.pub >> .ssh/authorized_keys # 将公钥添加到文件末尾，允许添加多个公钥
rm /home/server/id_rsa.pub  # 删除复制过来的源文件

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


