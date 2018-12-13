---
title: architect
date: 2018-12-10 16:37:56
tags: 架构
categories: 架构
---
这里是一些简单的笔记，主要是为了构建知识体系以及方便查找，以后会分点详细撰文。

<!-- more -->

## 架构学习笔记

1. 前端
	1. HTML/CSS/JavaScript
	2. 框架：Vue、Backbone、jQuery、LESS
	3. 构建工具：Webpack、Gulp、Grunt
	4. 其他：NodeJS
2. 数据交互
	1. protobuf123:smaller，faster，simpler
	2. Apache Thrift、Apache Avro
	1. json:{}
	2. xml:<tag\><\tag>
	3. 接口规范：
		1. 响应报文：code、msg、data
		2. 请求数据：参数
		3. 参数校验：正则表达式
	4. api：RESTful风格
		1. GET获取一个资源；POST添加一个资源；PUT修改一个资源；DELETE删除一个资源
		2. HTTP状态码：200 OK；400 Bad Request；500 Internal Server Error
	3. 服务发现
		1. erueka
		1. 在一个微服务应用中，一组运行的服务实例是动态变化的，实例有动态分配的网络地址，因此，为了使得客户端能够向服务发起请求，必须要要有服务发现机制。
		2. 客户端发现：客户端直接	查询服务注册表；服务端发现：客户端通过路由发起请求
3. 后端
	1. 框架
		1. JAVA：Spring／SpringMVC／**SpringBoot**／SpringCloud
		2. C++：性能最佳
		3. GO：iris、Revel、beego、buffalo、echo、gin
			1. https://blog.csdn.net/dev_csdn/article/details/78740990
		4. PHP：Laravel、Yii、Symfony、ThinkPHP、Codeigniter
		5. python：Django、Flask、Tornado、Aiohttp
		6. Tomcat：java服务器；apache：html服务器；Nginx：替代apache
	2. 数据库
		1. mysql、mariadb
		2. ORM：**MyBatis**封装jdbc，用xml执行语句，解除sql语句与代码的耦合；hibernate
		3. **Redis**：key-value数据库，数据库缓存，二级缓存改善用户体验
		4. 散列分库
		5. 读写分离：主数据库提供写操作，从数据库提供读操作，写操作后再同步两个数据库
		6. 关系型数据库满足ACID
		7. 纵向扩展横向扩展，关系型横向扩展：主从复制（读写分离）、集群（多个实例）、分片（分表分库）
		8. 分布式系统满足CAP定理
		9. key-value是nosql的一种，Memcached使用内存，Redis对数据进行了持久化，pika基于rocksdb上面兼容了redis的协议，解决的是用户使用 Redis 的内存大小超过 50G、80G 等等这样的情况
	4. 消息队列
		1. 耦合两个系统，提高系统吞吐率
		2. 可以根据一定的规则订阅读取请求
		3. **kafka**解决大量日志的传输问题
		4. 点对点通讯
		5. 异步处理
	6. 搜索
		1. Elasticsearch全文搜索
	7. HTTP Cache
8. 开发工具
	1. 构建工具：
		1. make:makefile,linux原始
		2. ant:xml,思路类似make, init/compile/build/test；没办法管理依赖
		3. maven:xml,给每个包都标上坐标，这样，便于在仓库里进行查找
		4. gradle:groovy,构建任务添加log
4. 基础架构
5. 其他
	1. 热闹驱动开发（Hype Driven Development，HDD）
	2. gossip as a service
	3. RESTful
	4. docker、kubernetes
	5. 技术选型	
	6. 微服务架构
	7. 网页浏览的步骤
		1. DNS解析
			1. 浏览器缓存
			2. hosts
			3. 域名解析服务器
			4. 根域服务器
			5. 1-4某步骤得到ip后就返回浏览器
			6. 对获得的ip发起TCP请求，从本机的1024<随机端口<65535到服务器的80端口
		2. 负载均衡：将用户分摊到两个或多个服务器上的方法叫负载均衡，balancer and worker
		3. web服务器
		4. 浏览器渲染
	5. 大型系统设计
		1. 描述使用场景、约束和假设、
		2. 创造一个高层级的设计
		3. 设计核心组件
		4. 度量设计
	5. SOA是Service Oriented Architecture的缩写，面向服务架构
6. 出现的问题
	1. 不用文章的id而是用文章的拼音缩写，SEO