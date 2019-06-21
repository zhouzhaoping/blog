---
title: git使用技巧
urlname: git-tips
date: 2019-01-17 17:02:37
tags: 
- Git
- 版本管理
- 笔记
categories: 版本管理
---
这是git使用时的一些tips，方便日后查询。
<!-- more -->

## add
同时对删除文件进行操作  
`git add --all`

## 创建与合并分支
查看分支
```bash
$ git branch -r #查看远程分支
$ git branch -a  #查看所有分支
```
克隆线上分支
```bash
$ git checkout -t origin/2.0.0 #已经 clone了 master分支
$ git clone -b test https://github.xxxx.git #如果尚未克隆，那么
```
先创建并切换分支
```bash
$ git branch dev // 创建
$ git checkout dev // 切换
Switched to branch 'dev'
```
此时修改当前分支，并且进行提交
```bash
$ git commit -m "branch test"
```
切换回想要merge的分支，并进行merge
```bash
$ git checkout master
Switched to branch 'master'
$ git merge dev
```
删除开发分支
```bash
$ git branch -d dev
```

## 删除不小心add的文件
```bash
git rm --cached path/to/file
```

## 改变最近一次提交
```bash
git commit --amend
``` 

## Git pull 强制覆盖本地文件
git fetch --all   
git reset --hard origin/master   
git pull

## git pull 报错
error: Your local changes to the following files would be overwritten by merge:  
原因：本地修改还没上传就pull了
1. 想保存原来的修改：
    ```
    git stash
    git pull origin master
    git stash pop
    ```
2. 覆盖本地代码
    ```
    git reset --hard
    git pull origin master
    ```
    
## 自学git命令的网站
[https://learngitbranching.js.org/](https://learngitbranching.js.org/)
