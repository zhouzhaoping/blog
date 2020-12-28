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
$ git push origin dev:dev // 上传新建的分支
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
$ git merge dev（也可以制定版本号）
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
```bash
git fetch --all   
git reset --hard origin/master   
git pull
```

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
    
## 不小心修改主分支
在主分支上， 新建分支  
git branch feature/new  
舍弃主分支上的修改  
git reset --hard  
进入已保存的新分支  
git checkout feature/new 

## 自学git命令的网站
[https://learngitbranching.js.org/](https://learngitbranching.js.org/)

## 代理下使用git
```bash
git config --global http.proxy 'socks5://127.0.0.1:10808'
git push

# 取消代理
git config --global --unset http.proxy 
git config --global --unset https.proxy 
```

## 查看所有配置
```bash
git config --global --list
```

## 修改git地址
```bash
git remote set-url origin git@code.sohuno.com:mp-recommend/wap-article.git
```

## 暂时保存修改
切换branch的时候可以线用stash把工作先保存
1. git stash：保存当前工作进度，会把暂存区和工作区的改动保存起来。
2. git stash list：显示保存进度的列表。
3. git stash pop [–index] [stash_id] 恢复最新的进度到工作区。git默认会把工作区和暂存区的改动都恢复到工作区。
4. git stash apply [–index] [stash_id] 除了不删除恢复的进度之外，其余和git stash pop 命令一样。
5. git stash drop [stash_id] 删除一个存储的进度。如果不指定stash_id，则默认删除最新的存储进度。
6. git stash clear：删除所有存储的进度。

### 修改错分支，未提交
```bash
git stash
git checkout dev
git stash pop
```
