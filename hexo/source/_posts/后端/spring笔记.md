---
title: spring笔记
urlname: spring-tips
date: 2019-04-16 10:17:43
tags: 
- 后端
- Spring
- 笔记
categories: 后端
---
这是spring使用时的一些tips。
<!-- more -->

## 打包上传
要把构建(jar包)部署到Nexus，需要在pom文件中定义distributionManagement来提供仓库URL，然后运行mvn deploy。Maven会执行一个HTTP的PUT请求将POM和构建推入至你的Nexus。  
账号密码配置在`./m2/setting.xml`文件中


## 运行时找不到bean
工程添SpringBootApplication加注解
```java
@ComponentScan(basePackages = {"com.sohu"})
```

## 依赖包强更新
依赖包下载之后会放到缓存中，假如有新包打包上传成功后，如果版本号没有变，很有可能导致新包不能立即生效。maven的reimport也没有用，因为每次使用的包都是缓存的。  
如果是Maven遇到不能刷新本地依赖的话，需要做两件事情：
1. 到~/.m2下，看看jar包路径是不是带有”.lastUpdated”，有的话就删除之。
2. 带参数强制刷新mvn build -U
