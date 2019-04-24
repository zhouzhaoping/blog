---
title: Golang-tips
date: 2019-04-18 14:37:52
tags:
- 后端
- Golang
categories: Backend
---
这是Golang使用时的一些tips。
<!-- more -->

## init
1. init()函数会在每个包完成初始化后自动执行，并且执行优先级比main函数高。
2. golang包初始化：
    1. 初始化导入的包（递归导入）
    2. 对包块中声明的变量进行计算和分配初始值
    3. 执行包中的init函数

3. 即使包被导入多次，初始化只需要一次。  
4. Go要求非常严格，不允许引用不使用的包。但是有时你引用包只是为了调用init函数去做一些初始化工作。此时空标识符（也就是下划线）的作用就是为了解决这个问题。
```go
import _ "image/png"
```

## 日志
spring生产环境中使用logback作为日志模块，golang里有没有对应的包能提供类似的日志分割的功能呢？找到一个logrus，https://www.jishuwen.com/d/2Ek8

