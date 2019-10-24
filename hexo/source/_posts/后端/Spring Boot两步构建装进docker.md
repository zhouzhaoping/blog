---
title: Spring Boot两步构建装进docker
urlname: docker-springboot
date: 2019-10-23 18:10:43
tags: 
- 后端
- Spring
- Docker
- 教程
categories: 后端
---

最近发现公司持续集成的构建方式（可视化配置出dockerfile）实在太不可控，于是自己写了一个dockerfile两步构建spring boot。
<!-- more -->

## Dockerfile
废话少说，先上代码
```dockerfile
# 基础镜像
FROM maven:3.5-jdk-8 AS build-env

# 镜像维护人员
MAINTAINER zhouzhaoping@gmail.com

# 编译操作
COPY ./ /
WORKDIR /
RUN ./download.sh test && mvn clean package -DskipTests=true

# 运行镜像
FROM openjdk:8-jre

# 拷贝编译好的jar包放进运行镜像
COPY --from=build-env /target/wap-article-0.0.1-SNAPSHOT.jar /opt/app.jar

# 创建日志文件夹
WORKDIR /opt/logs
RUN mkdir -p /opt/logs/gc

# 安装dumb-init
RUN wget  --no-check-certificate -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/bin/dumb-init
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# 读取配置文件，运行
EXPOSE 10020
CMD  java -Dfile.encoding=utf-8 -Duser.timezone=GMT+08 -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE} -Djson.view.enabled=${JSON_VIEW_ENABLED} -Denv=${APOLLO_ENV} ${OPTIONS} -jar /opt/app.jar $ARGS
```

## 两步构建
**多步构建(Multi-stage build)**，这样就可以通过单个Dockerfile使用多个中间镜像用于构建、测试、发布，并且有效减小最终镜像的大小。一般在这上面能找到相关镜像[hub.docker](https://hub.docker.com/)、[github](https://github.com/docker-library/official-images)。  
我们选取`maven:3.5-jdk-8`作为编译镜像，编译完之后把打包好的jar包放到运行镜像`openjdk:8-jre`中，这个运行的镜像包含了能够跑起来springboot jar包的最小环境（一般来说现在流行使用alpine的镜像）。
```bash
# docker images
wap-article                   latest               a77312d39b1d        10 hours ago        295MB
```
现在的运行镜像和原来487MiB的镜像相比，压缩了将近一半。

## 优雅退出
**进程的优雅退出（Gracefully Exiting）** 对服务来说是一件很重要的事情，但是只要正确捕捉SIGTERM 等信号一般都不会有什么大问题，但是在容器中会出现一些不可预料的结果。  
在一个容器启动的时候，CMD 或者 ENTRYPOINT 里定义的命令会作为容器的主进程（main process）启动，pid 为 1，一旦主进程退出了，容器也会被销毁，容器内其他进程会被 kernel 直接 kill。shell 来启动程序，有时候会是后台进程，如果 shell 退出会导致子进程全部退出，应该会是个大麻烦。  
我们在docker中有时候会用shell来启动程序，但是shell不转发signals同时还不响应退出信号。因为 kernel 会为每个进程加上默认的 signal handler，例外的是 pid=1 的进程，被 kernel 当作一个 init 角色，不会给他加上默认的 handler，可如果在容器中启动 shell，占据了 pid=1 的位置，这个容器就无法正常退出了，只能等 docker 引擎在超时后强行杀死进程。信号并没有被很好的处理和传递，孤儿僵尸进程没有被正确的收割。    
假如我们使用[dumb-init](https://github.com/Yelp/dumb-init)作为预启动钩子，启动java程序，那作为容器中的主进程，当它在收到退出信号的时候，会将退出信号转发给进程组所有进程。
```dockerfile
# 安装dumb-init
RUN wget  --no-check-certificate -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/bin/dumb-init
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
```
我们可以看一下有没有使用dumb-init的区别：


{% tabs 选项卡, 2 %}
<!-- tab 未使用dumbinit -->
{% codeblock lang:bash %}
# ps -ef
UID         PID   PPID  C STIME TTY          TIME CMD
root          1      0  0 06:55 ?        00:00:00 /bin/sh -c java -Dfile.encoding=utf-8 -Duser.timezone=GMT+08 -Dspring.pr
root          6      1  5 06:55 ?        00:01:13 java -Dfile.encoding=utf-8 -Duser.timezone=GMT+08 -Dspring.profiles.acti
root         28      0  0 06:55 pts/0    00:00:00 sh
root        339     28  0 07:16 pts/0    00:00:00 ps -ef
{% endcodeblock %}
<!-- endtab -->
<!-- tab 使用dumbinit -->
{% codeblock lang:bash %}
# ps -ef
UID         PID   PPID  C STIME TTY          TIME CMD
root          1      0  0 04:49 ?        00:00:00 /usr/bin/dumb-init -- /bin/sh -c java -Dfile.encoding=utf-8 -Duser.timezone=GMT+08 -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE} -Djson.view.enabled=${JSON_VIEW_ENABLED} -D
root          6      1  0 04:49 ?        00:00:00 /bin/sh -c java -Dfile.encoding=utf-8 -Duser.timezone=GMT+08 -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE} -Djson.view.enabled=${JSON_VIEW_ENABLED} -Denv=${APOLLO_ENV} ${OP
root          7      6  1 04:49 ?        00:01:25 java -Dfile.encoding=utf-8 -Duser.timezone=GMT+08 -Dspring.profiles.active=dev -Djson.view.enabled=true -Denv=dev -Xms2048m -Xmx2048m -Xmn1024m -Xss256k -XX:+UseParNewGC -XX:+Us
root         61      0  0 04:50 pts/0    00:00:00 sh
root        469     61  0 06:30 pts/0    00:00:00 ps -ef
{% endcodeblock %}
<!-- endtab -->
{% endtabs %}

可以发现上面的pid=1变成了dumb-init
