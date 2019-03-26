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
	4. RPC
	    - [rpc轮子](http://www.buildupchao.cn/2019/02/01/%E8%AE%BE%E8%AE%A1%E4%B8%80%E4%B8%AA%E5%88%86%E5%B8%83%E5%BC%8FRPC%E6%A1%86%E6%9E%B6/?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)
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
	8. 雪崩，熔断，降级
	    - 一个服务失败，导致整条链路的服务都失败的情形，我们称之为服务雪崩
	    - 服务熔断和服务降级就可以视为解决服务雪崩的手段之一
	    - 服务熔断：当下游的服务因为某种原因突然变得不可用或响应过慢，上游服务为了保证自己整体服务的可用性，不再继续调用目标服务，直接返回，快速释放资源。如果目标服务情况好转则恢复调用。
	    - 一般使用断路器模式
	    - 当下游的服务因为某种原因不可用，上游主动调用本地的一些降级逻辑，避免卡顿，迅速返回给用户！
	    - 开关降级、限流降级、熔断降级
8. 开发工具
	1. 构建工具：
		1. make:makefile,linux原始
		2. ant:xml,思路类似make, init/compile/build/test；没办法管理依赖
		3. maven:xml,给每个包都标上坐标，这样，便于在仓库里进行查找
		4. gradle:groovy,构建任务添加log
4. 基础架构
    1. 指标
        1. RPS(Requests Per Second)：系统在单位时间内（每秒）处理请求的数量。  
        2. QPS(Query Per Second)：是指在一定并发度下，服务器每秒可以处理的最大请求数。
        3. 服务器平均请求处理时间 = 1/QPS（秒）
        4. 平均等待时间 = 1/(QPS/并发度) = 并发度/QPS（秒）。
    2. 对策
        1. 百RPS——升级机器配置
        2. 千RPS——各组件拆分并优化
        3. 万RPS——水平扩展
        4. 十万、百万、千万RPS——终极拆分及扩展
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
6. 如何快速熟悉一个新项目
    1. 源码位置、部署环境：所谓项目，其实就是一堆代码放在了一堆机器上而已
    2. 从页面到数据库
    3. 了解项目间的关系
    4. 整理数据库表，整理Controller层的所有接口
    5. 深入代码层
        1. 通过交互对自身数据库进行增删改查操作
        2. 通过定时任务或服务器脚本对自身数据库进行增删改查操作
        3. 调用或通知其他服务做一些事情
