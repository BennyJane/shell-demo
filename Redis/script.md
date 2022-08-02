
### 脚本语法

```shell
EVAL script numkeys [key [key ...]] [arg [arg ...]]
```
script：Lua脚本。
numkeys：指定KEYS[]参数的数量，非负整数。
KEYS[]：传入的Redis键参数。
ARGV[]：传入的脚本参数。KEYS[]与ARGV[]的索引均从1开始。

与SCRIPT LOAD命令一样，EVAL命令也会将Lua脚本缓存至Redis。

```shell
SCRIPT LOAD script
```
将给定的script脚本缓存在Redis中，并返回该脚本的SHA1校验和


```shell
EVALSHA sha1 numkeys key [key ...] arg [arg ...]
```
给定脚本的SHA1校验和，Redis将再次执行脚本。
使用EVALSHA命令时，若sha1值对应的脚本未缓存至Redis中，
Redis会返回NOSCRIPT错误，
请通过EVAL或SCRIPT LOAD命令将目标脚本缓存至Redis中后进行重试

```shell
SCRIPT EXISTS script [script ...]
```
给定一个（或多个）脚本的SHA1，返回每个SHA1对应的脚本是否已缓存在当前Redis服务。
脚本已存在则返回1，不存在则返回0。

```shell
SCRIPT KILL
停止正在运行的Lua脚本

SCRIPT FLUSH
清空当前Redis服务器中的所有Lua脚本缓存
```


### 案例

```shell
set foo value_test

EVAL "return redis.call('GET', KEYS[1])" 1 foo
# "value_test"

SCRIPT LOAD "return redis.call('GET', KEYS[1])"
# "620cd258c2c9c88c9d10db67812ccf663d96bdc6" 

EVALSHA 620cd258c2c9c88c9d10db67812ccf663d96bdc6 1 foo
# "value_test"


SCRIPT EXISTS 620cd258c2c9c88c9d10db67812ccf663d96bdc6 ffffffffffffffffffffffffffffffffffffffff
#1) (integer) 1
#2) (integer) 0




```