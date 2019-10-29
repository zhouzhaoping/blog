---
title: Linux工具快速教程
urlname: linux-tools
date: 2019-06-10 15:38:38
tags: 
- 工具
- 教程
- Linux
categories: 
- 工具
---
这是linux命令行工具使用时的一些tips，方便日后查询。
<!-- more -->

## 帮助
```bash
$whatis command
简要说明
$info command
详细说明
$man command
说明文档
$which command
安装路径
$whereis command
搜索路径（不确定使用的版本）
```
man的分类标识
> (1)、用户可以操作的命令或者是可执行文件  
(2)、系统核心可调用的函数与工具等  
(3)、一些常用的函数与数据库  
(4)、设备文件的说明  
(5)、设置文件或者某些文件的格式  
(6)、游戏  
(7)、惯例与协议等。例如Linux标准文件系统、网络协议、ASCⅡ码等说明内容  
(8)、系统管理员可用的管理条令  
(9)、与内核有关的文件  

```bash
$whatis -w "print*"
print_access_vector (3) - convert between SELinux class and permission values and string names. print_access_vector - display an access vector in human-readable form.
printafm (1)         - Print the metrics from a Postscript font in AFM format using ghostscript
printenv (1)         - print all or part of environment
printers.conf (5)    - printer configuration file for cups
printf (1)           - format and print data
printf (3)           - formatted output conversion
正则匹配
$man 3 printf
```

## 文件管理
### 创建删除
```bash
创建：mkdir
删除：rm
删除非空目录：rm -rf file目录
删除日志 rm *log (等价: $find ./ -name “*log” -exec rm {} ;)
移动：mv
复制：cp (复制目录：cp -r source_dir  dest_dir)
```

### 目录切换
```bash
找到文件/目录位置：cd
切换到上一个工作目录： cd -
切换到home目录： cd or cd ~
显示当前路径: pwd
更改当前工作路径为path: $cd path
```

### 查找
```bash
搜寻文件或目录:
$find ./ -name "core*" | xargs file
查找目标文件夹中是否有obj文件:
$find ./ -name '*.o'
递归当前目录及子目录删除所有.o文件:
$find ./ -name "*.o" -exec rm {} \;
find是实时查找，如果需要更快的查询，可试试locate；locate会为文件系统建立索引数据库，如果有文件更新，需要定期执行更新命令来更新索引库:
$locate string
寻找包含有string的路径:
$updatedb
与find不同，locate并不是实时查找。你需要更新数据库，以获得最新的文件索引信息。
```

### 查看文件
```bash
显示时同时显示行号:
$cat -n
按页显示列表内容:
$ls -al | more
只看前10行:
$head - 10 **
显示文件第一行:
$head -1 filename
显示文件倒数第五行:
$tail -5 filename
查看两个文件间的差别:
$diff file1 file2
动态显示文本最新信息:
$tail -f crawler.log
```

### 查找文件
```bash
egrep '03.1\/CO\/AE' TSF_STAT_111130.log.012
egrep 'A_LMCA777:C' TSF_STAT_111130.log.035 > co.out2
```

### 文件与目录权限修改
```bash
改变文件的拥有者 chown
改变文件读、写、执行等属性 chmod
递归子目录修改： chown -R tuxapp source/
增加脚本可执行权限： chmod a+x myscript
```

### 文件别名
```bash
ln cc ccAgain :硬连接；删除一个，将仍能找到；
ln -s cc ccTo :符号链接(软链接)；删除源，另一个无法使用；（后面一个ccTo 为新建的文件）
```

###  管道和重定向
    批处理命令连接执行，使用 |
    串联: 使用分号 ;
    前面成功，则执行后面一条，否则，不执行:&&
    前面失败，则后一条执行: ||
    
## 文本处理

https://github.com/jaywcjlove/linux-command

