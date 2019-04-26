---
title: 十分钟hexo装进docker
urlname: docker-hexo
date: 2018-12-13 15:49:02
tags: 前端
categories: 前端
---
作为一个业余前端，为了写博客，只想关注内容而不是复杂的node环境和nmp依赖，因此把hexo装进docker成为了最好的选择。

<!-- more -->

## 食用前提
本文的基础是已经学会使用docker，同时对hexo有基本的了解

## Dockerfile
废话少说，直接看Dockerfile
```Dockerfile
FROM node:11.1.0-alpine

RUN apk add --update --no-cache git
RUN npm config set unsafe-perm true \
    && npm install hexo-cli -g

WORKDIR /Hexo

EXPOSE 4000
```
接下来我们构建镜像
```bash
docker build -t hexo-docker .
```
因此这个hexo-docker镜像就有了hexo运行的环境

## 初始化
在第一次运行的时候，`$work_path`是我们当前的目录，我们需要hexo初始化并且把生成的文件放到docker中的Hexo目录，由于这个目录和`$work_path/hexo`挂载，因此生成的文件都在`$work_path/hexo`里
```bash
docker run -it \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    sh -c 'hexo init . && npm install && npm install hexo-deployer-git --save'
```

## 编辑
接下来我们开始编辑，`hexo new`之后生成的markdown文件都在`$work_path/hexo/_posts`里，可以找到生成的文件进行编辑
```bash
cd $work_path/hexo
hexo new "My New Post"
```

## 生成网页文件
把`markdown`文件渲染生成html文件
```bash
docker run -it \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    hexo g
```

## 预览网页
默认使用4000端口，在这个基础上可以用ngnix进行映射
```bash
docker run -it -d \
    -p 4000:4000 \
    -v $work_path/hexo:/Hexo \
    hexo-docker \
    hexo s
```

## 例子
这个博客就是用这种方式部署到一个512MB的内存和11GB的存储空间的小机器上的。可以参考[https://github.com/zhouzhaoping/blog](https://github.com/zhouzhaoping/blog)
