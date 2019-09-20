---
title: 科学上网指南：VPS+BBR+SSR
urlname: circumvention_technology_vps_bbr_ssr
date: 2019-06-24 16:36:28
tags: 
- 工具
- 日记
- 个人网站
- 教程
categories: 
- 工具
---
这是一个简单科学上网的教程。

<!-- more -->

## 前言
由于众所周知的原因，在六一节前几天我的科学上网工具（搬瓦工+ss）挂了，排查了一下发现是ip被封了。当前搬瓦工的策略是换ip需要加钱，刚好我的服务器快到期了于是就放弃了。为了苟营这个小站，也为了能面向谷歌编程，我需要尽快买到一个vps。

## 购买VPS
按理说ss应该已经足够安全，此次被封可能是由于异常流量被检测到，一片机房被集体连坐上黑名单。被连坐主要是由于机房内大量vps用于翻墙导致被玩坏，所以此时的策略就是要挑一个冷门的vps供应商。  
经过大量的调查之后，找到了一个叫[Hostwinds](https://www.hostwinds.com)的vps供应商，更惊喜的是官网还不用翻墙，只需要4.99美元一月即可拥有，而且还能使用支付宝支付。为了避免被封导致损失，我先买了一个月来尝尝鲜。机房选择了最近都没有报过被封的达拉斯机房，系统选择centos。
```bash
# cat /etc/redhat-release
CentOS Linux release 7.6.1810 (Core) 
```

## 安装BBR
Google BBR (Bottleneck Bandwidth and RTT) 是一种新的TCP拥塞控制算法,它可以高效增加吞吐和降低网络延迟，并且Linux Kernel4.9+已经集成该算法。  

### 升级内核
```bash
# uname -r 
3.10.0-693.2.2.el7.x86_64
```
查询了一下系统内核发现只有3.10，这时需要升级一下系统内核  
首先先安装elrepo并升级内核
```bash
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y
```
确认是否安装成功
```bash
# egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
0 : CentOS Linux (5.1.14-1.el7.elrepo.x86_64) 7 (Core)
1 : CentOS Linux 7 Rescue 49418d6d23134c1eb3337d6ca9c82c30 (3.10.0-957.21.3.el7.x86_64)
2 : CentOS Linux (3.10.0-957.21.3.el7.x86_64) 7 (Core)
3 : CentOS Linux (3.10.0-693.2.2.el7.x86_64) 7 (Core)
4 : CentOS Linux (3.10.0-514.26.2.el7.x86_64) 7 (Core)
5 : CentOS Linux (0-rescue-de149d15bc21de2e4cc85376c8c61208) 7 (Core)
```
第一个就是我们新安装的内核（即第0个，从0开始计数），下面设置启动项并重启
```bash
# grub2-set-default 0
# reboot
```
重启之后发现内核更换成功
```bash
# uname -r
5.1.14-1.el7.elrepo.x86_64
```

### 配置BBR
把内核升级到4.9以上之后，我们只要修改配置就能开启BBR了
```bash
1. 编辑配置文件
# vi /etc/sysctl.conf
2、添加如下内容
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
3. 加载系统参数（正常情况下会输出我们之前加入的内容）
# sysctl -p 
```
验证开启成功没有
```bash
# sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = reno cubic bbr
# lsmod | grep bbr
tcp_bbr                20480  1 
```

## 安装SSR
Shadowsocks既可以指一种基于 Socks5 代理方式的加密传输协议，也可以指实现这个协议的各种开发包。目前包使用 Python、C、C++、C#、Go 等编程语言开发，大部分主要实现（iOS 平台的除外）采用 Apache 许可证、GPL、MIT 许可证等多种自由软件许可协议开放源代码。Shadowsocks 分为服务器端和客户端，在使用之前，需要先将服务器端部署到服务器上面，然后通过客户端连接并创建本地代理。ShadowsocksR 是 breakwa11 发起的 Shadowsocks 分支，在 Shadowsocks 的基础上增加了一些数据混淆方式，称修复了部分安全问题并可以提高 QoS 优先级。后来贡献者 Librehat 也为 Shadowsocks 补上了一些此类特性，甚至增加了类似 Tor 的可插拔传输层功能。

### 安装
使用一键安装脚本
```bash
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh
chmod +x shadowsocksR.sh
./shadowsocksR.sh 2>&1 | tee shadowsocksR.log
```

### 配置
配置文件路径：/etc/shadowsocks.json  
日志文件路径：/var/log/shadowsocks.log  
代码安装目录：/usr/local/shadowsocks  
卸载：./shadowsocksR.sh uninstall  
查看状态：/etc/init.d/shadowsocks status  
启动：/etc/init.d/shadowsocks start  
停止：/etc/init.d/shadowsocks stop  
重启：/etc/init.d/shadowsocks restart 

### 多用户配置
```json
{
  "server":"0.0.0.0",
  "server_ipv6": "[::]",
  "local_address":"127.0.0.1",
  "local_port":1080,
  "port_password":{
    "8989":"password1",
    "8990":"password2",
    "8991":"password3"
  },
  "timeout":300,
  "method":"aes-256-cfb",
  "protocol": "origin",
  "protocol_param": "",
  "obfs": "plain",
  "obfs_param": "",
  "redirect": "",
  "dns_ipv6": false,
  "fast_open": false,
  "workers": 1
}
```
[混淆协议介绍](https://profbinary.com/SSR%E7%9A%84%E6%B7%B7%E6%B7%86%E5%92%8C%E5%8A%A0%E5%AF%86%E5%8D%8F%E8%AE%AE%E4%BB%8B%E7%BB%8D/)

### 客户端使用
电脑：chrome安装switchomega插件配合ss客户端  
手机：ss手机版客户端    
ios：shadowrocket    
linux：cow作为客户端
```bash
# vim ~/.cow/rc 
listen = http://0.0.0.0:7777
proxy = ss://aes-128-cfb:password@1.2.3.4:8388
# export http_proxy=http://127.0.0.1:7777
# export https_proxy=http://127.0.0.1:7777
```

windows命令行：
```bash
# set http_proxy=127.0.0.1:1080
# set https_proxy=127.0.0.1:1080
```

