---
title: git使用技巧
date: 2019-01-17 17:02:37
tags: Git
categories: Version-control
---
这是git使用时的一些tips，方便日后查询。
<!-- more -->

## 创建与合并分支
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
删除不小心add的文件
```bash
git rm --cached path/to/file
```
## 自学git命令的网站
[https://learngitbranching.js.org/](https://learngitbranching.js.org/)
