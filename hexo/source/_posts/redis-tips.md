---
title: redis使用tips
date: 2018-12-20 15:52:25
tags:
---
## 登陆
```bash
redis-cli -h your_ip -p your_port -a your_password
```
## 查询
```bash
scan 0 match yourkey_pre*
ttl key
keys yourkey_pre
```

## 查找ttl=-1的key
```bash
redis-cli  -h your_ip -p your_port -a your_password --scan --pattern "*" | awk '{printf "echo " $1 "\r\nttl " $1 "\r\n"}' | redis-cli  -h your_ip -p your_port -a your_password --csv | awk '!(NR%2){if($0 = -1) {print p     "," $0}}{p=$0}' >> hehe.log
```
