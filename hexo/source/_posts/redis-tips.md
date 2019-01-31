---
title: redis笔记
date: 2018-12-20 15:52:25
tags: 
- 后端
- KV
- K8s
categories: Backend
---
这是redis使用时的一些tips，包括一个查找所有不过期数据简单脚本，方便彻查redis不规范的使用方法。
<!-- more -->
## 不同模式
1. 单点模式：一个实例。
2. 主从模式（master/slaver）：
    - 1主N从，默认配置master读写slave只能读
    - slave挂掉之后重启会从master同步过来，master挂掉之后slave不会竞选为master
    - 主库的存储能力受到单机的限制，可以考虑**Pika**
3. 哨兵模式（sentinel）：针对故障转移
    - master节点挂了以后，sentinel会在slave中选择一个做为master；master重新启动后，它将不再是master，而是作为slave接收新的master节点的同步信息
    - 心跳机制+投票裁决
4. 集群模式（cluster）：针对并发
    - 一个redis集群有16384（2^14）个hash slot，使用虚拟槽解决了一致性哈希分区中的节点变化问题。

## 持久化
避免挂了之后重启时的内存数据丢失，有RDB和AOF两种方式。  
- RDB：在指定的时间间隔内生成数据集的时间点快照（point-in-time snapshot）。dump.rdb
- AOF：记录服务器执行的所有写操作命令，并在服务器启动时，通过重新执行这些命令来还原数据集。 

## 登陆
```bash
redis-cli -h your_ip -p your_port -a your_password
```

## 基本信息
```bash
info //基本信息
cluster nodes //集群的结点状况
cluster info //集群状态
```

## 查询key
谨慎使用keys操作
```bash
scan 0 match yourkey_pre*
ttl key
keys yourkey_pre*
redis-cli --bigkeys
```

## 查找ttl=-1的key
```bash
redis-cli  -h your_ip -p your_port -a your_password --scan --pattern "*" | awk '{printf "echo " $1 "\r\nttl " $1 "\r\n"}' | redis-cli  -h your_ip -p your_port -a your_password --csv | awk '!(NR%2){if($0 = -1) {print p     "," $0}}{p=$0}' >> hehe.log
```
下面是Codis版：（由于codis不支持`scan`命令，所以只能用`slotsscan`代替）
```python
for slot in range(1024):
    cursor = 0
    while True:
        cursor, keys = conn.execute_command("SLOTSSCAN", slot, cursor)
        do_something(keys)
        if cursor == 0:
            break
```

## 数据分析
下载安装dump.rdb文件的数据分析工具[https://github.com/sripathikrishnan/redis-rdb-tools](https://github.com/sripathikrishnan/redis-rdb-tools)
```bash
yum  install python-devel
pip install rdbtools python-lzf
```
使用redis的dump备份做数据分析，以免影响线上服务
```bash
redis-cli -c -h 10.18.36.141 -p 6390 -a 35ff9e22 --rdb ~/dump.rdb // 把dump.rdb文件下载到本地
rdb -c memory /path/to/your/dump.rdb --bytes 10240 --type string > result.csv // 找到redis中的string类型的大key（大于10240）
```

