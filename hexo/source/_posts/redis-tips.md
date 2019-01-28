---
title: redis使用tips
date: 2018-12-20 15:52:25
tags: 
- 后端
- KV
- K8s
categories: Backend
---
这是redis使用时的一些tips，包括一个查找所有不过期数据简单脚本，方便彻查redis不规范的使用方法。
<!-- more -->
## 登陆
```bash
redis-cli -h your_ip -p your_port -a your_password
```
## 查询
```bash
scan 0 match yourkey_pre*
ttl key
keys yourkey_pre*
```

## 查找ttl=-1的key
```bash
redis-cli  -h your_ip -p your_port -a your_password --scan --pattern "*" | awk '{printf "echo " $1 "\r\nttl " $1 "\r\n"}' | redis-cli  -h your_ip -p your_port -a your_password --csv | awk '!(NR%2){if($0 = -1) {print p     "," $0}}{p=$0}' >> hehe.log
```

## 查找ttl=-1的key，Codis版
由于codis不支持`scan`命令，所以只能用`slotsscan`代替
```python
for slot in range(1024):
    cursor = 0
    while True:
        cursor, keys = conn.execute_command("SLOTSSCAN", slot, cursor)
        do_something(keys)
        if cursor == 0:
            break
```
