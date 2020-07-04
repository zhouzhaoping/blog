---
title: 科学上网指南2：Cloudflare+V2ray
urlname: circumvention_technology_cloudflare_v2ray
date: 2019-09-18 15:25:55
tags: 
- 工具
- 日记
- 个人网站
- 教程
categories: 
- 工具
---

IP被墙了，ssh连不上，谷歌登不上，小站再次陷入危机。刚续费的vps还能抢救吗？这时候免费CDN站出来了，CDN几乎无限的ip池做我们的代理足够了。生命不息战斗不止，魔高一丈道高一尺。

<!-- more -->

## 前言&原理
2019年9月16日，刚续费（在7.0937的汇率高点）一个月的vps，IP被封了。距离上一次在搬瓦工被封IP(参考[科学上网指南：VPS+BBR+SSR](http://blog.zhouzhaoping.com/Tools/circumvention_technology_vps_bbr_ssr/))仅仅只过了不到三个月，国庆将至，小站再一次进入了危机，更惨的是只能面向百度编程了。回想起过去的岁月，从改hosts文件，再到谷歌云的goagent，再到搬瓦工，搬瓦工被封了之后转向hostwinds，短的可怜的空窗期里的无界浏览器、洋葱浏览器，相信这一次的危机也能立马度过。  
通过朋友的介绍，找到使用CDN中转的方法：先在服务器上用 v2ray 伪装成一个网站，再用 CDN 中转  
![pc-firewall-cdn-vps](/images/pc-firewall-cdn-vps.png)  
假如我们把域名放在CDN上加速，在CDN不被封的前提下(假如被封了那很多正常网站的运营都没办法展开)，CDN可以帮助我们代理访问到我们的vps，这样就算是ip被封杀了也能妥妥访问，然后借助vps上的代理帮我们访问境外网站。  
于是我们只要有了vps、域名、免费CDN就可以实现这个流程，为了避免在配置的过程又要发生相关的备案需求，所以我们尽量都选择国外的网络服务商：  
1. VPS：推荐[Hostwinds](https://www.hostwinds.com)（参考[科学上网指南：VPS+BBR+SSR 之 购买VPS](http://blog.zhouzhaoping.com/Tools/circumvention_technology_vps_bbr_ssr/#%E8%B4%AD%E4%B9%B0VPS)）最主要的优势是ssh被封了之后还能通过hostwinds服务器管理里的在线SSH功能用浏览器远程。
2. 域名：推荐[godaddy](https://godaddy.com/)（参考[个人网站搭建 之 购买域名](http://blog.zhouzhaoping.com/Tools/build-your-own-website/#%E8%B4%AD%E4%B9%B0%E5%9F%9F%E5%90%8D)）
3. CDN：[Cloudflare](https://www.cloudflare.com/)是一家国外的CDN全球加速服务商，支持https，它提供了不同的套餐，即使是免费的用户，它的CDN加速服务也很全面，除了全球CDN加速服务外，还有DDoS保护，域名解析，反向代理等等，免费SSL证书。  

前两步我们已经很熟悉了，在这里就不做赘述。

## CloudFlare CDN配置
1. 注册登陆
2. 添加域名，将域名交给 CloudFlare 管理
3. 选择套餐，这里我们选择 FREE 套餐
4. 补全域名的解析纪录，这时候最好上godaddy上看自己的域名的解析记录
5. 下一步要修改 Nameservers（域名服务器），这时候在godaddy的管理页面上把域名服务器修改成cloudflare给定的域名服务器地址
6. 选择 DNS，橘色云朵代表该解析记录使用 CDN，灰色云朵代表该解析记录不使用 CDN，点击云朵可以进行切换

## v2ray 服务端配置
### 安装&启动
1. 安装`bash < (curl -L -s https://install.direct/go.sh)`
2. 保存port和uuid
3. 启动`systemctl start v2ray`
4. 查看状态`systemctl status v2ray`

### 配置
修改配置文件/etc/v2ray/config.json，增加你喜欢的端口，并用 /usr/bin/v2ray/v2ctl uuid 命令随机生成id，路径可以随便配，例如/v2ray（这里的29615是默认生成的，我自己添加了一个29616用于翻墙，传输协议选择ws）：  
![v2ray_config1](/images/v2ray_config1.png)  
![v2ray_config2](/images/v2ray_config2.png)  

### 连接
windows：推荐[V2RayN](https://github.com/2dust/v2rayN/releases)，下载core直接启动
1. 添加VMess服务器，相关配置如下。**这里使用域名:80的原因是为了伪装成正常网站请求，把相关请求能成功通过CDN到达VPS，额外id和路径都与vps上的v2ray相对应**如果使用ip的话就不会过CDN而会被直接墙掉：
![v2rayN_config](/images/v2rayN_config.png) 
2. 点开参数设置，查看监听端口，例如10808
3. 使用chrome安装的switchomega插件把相关请求转发到10808端口

Android：推荐V2RayNG  
IOS：Shadowrocket，假如国区安装不了可以选择上网下载ipa文件，然后用一些同步助手的工具同步到ipad中。配置混淆的时候记得在路径的下面一行加入域名。

IOS：shadowrocket可以继续使用，但国区下不了，所以只能上网找ipa文件再用同步助手之类的工具安装

## 流量转发
vps上的v2ray监听的是`29616`，而我们翻墙时访问的是`v2ray.zhouzhaoping.com:80`，所以我们还需要用nginx转发相关请求。  
1. 增加配置文件`/etc/nginx/conf.d/vpn.conf` 
![v2ray_nginx_config](/images/v2ray_nginx_config.png) 
2. 重启v2ray、nginx
```bash
systemctl restart v2ray
systemctl restart nginx
```
使用流量转发之后，小站正常的流量（blog.zhouzhaoping.com)和翻墙的流量（v2ray.zhouzhaoping.com）就互不干扰了。

## 其它疑问
当前ip被封怎么远程的问题依然没有解决，假如运营商没有提供在线远程功能那我们这台机器就废了  
ios端暂时没有很好的连接方案  
[最新翻墙教程](https://program-think.blogspot.com/2019/06/gfw-news.html)
