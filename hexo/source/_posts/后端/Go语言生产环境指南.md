---
title: Go语言生产环境指南
urlname: go-in-producation
date: 2019-04-27 00:50:02
tags:
- 后端
- Golang
categories: 后端
---
为了让go不仅仅是一个demo，我们需要Golang在生产环境中实践。这个指南是一位一年级菜鸟后端工程师踩出的各种坑，充满了血与泪。

<!-- more -->

## 从面向对象到Go
Go的interface能满足90%以上的OOP需求，但又没有C++的种种陷阱；执行速度足够快。
### 泛型
1. interface{}
2. 反射

### 函数重载

## 数据连接
### redis
连接池优化

### mongo

## rpc
库加速

## 编译优化

## 运行优化
maxprocess

## 竞态检查

## 超时控制
context

## 优雅退出

## 日志
spring生产环境中使用logback作为日志模块，golang里有没有对应的包能提供类似的日志分割的功能呢？找到一个logrus，https://www.jishuwen.com/d/2Ek8
Hook模式

## debug
goroutine_id
https://liudanking.com/performance/golang-%E8%8E%B7%E5%8F%96-goroutine-id-%E5%AE%8C%E5%85%A8%E6%8C%87%E5%8D%97/

## 错误处理

## 单元测试

## 压测

## 性能优化
pprof工具
1. 减少临时对象
2. 循环并发
3. 编译优化

## 线程debug
