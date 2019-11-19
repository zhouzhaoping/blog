---
title: spring笔记
urlname: spring-tips
date: 2019-04-16 10:17:43
tags: 
- 后端
- Spring
- 笔记
categories: 后端
---
这是spring使用时的一些tips。
<!-- more -->

## 打包上传
要把构建(jar包)部署到Nexus，需要在pom文件中定义distributionManagement来提供仓库URL，然后运行mvn deploy。Maven会执行一个HTTP的PUT请求将POM和构建推入至你的Nexus。  
账号密码配置在`./m2/setting.xml`文件中


## 运行时找不到bean
工程添SpringBootApplication加注解
```java
@ComponentScan(basePackages = {"com.zzp"})
```

## 依赖包强更新
依赖包下载之后会放到缓存中，假如有新包打包上传成功后，如果版本号没有变，很有可能导致新包不能立即生效。maven的reimport也没有用，因为每次使用的包都是缓存的。  
如果是Maven遇到不能刷新本地依赖的话，需要做两件事情：
1. 到~/.m2下，看看jar包路径是不是带有”.lastUpdated”，有的话就删除之。
2. 带参数强制刷新mvn build -U

## 分层领域模型规约：
1. DO（ Data Object）：与数据库表结构一一对应，通过DAO层向上传输数据源对象。
2. DTO（ Data Transfer Object）：数据传输对象，Service或Manager向外传输的对象。
3. BO（ Business Object）：业务对象。 由Service层输出的封装业务逻辑的对象。
4. AO（ Application Object）：应用对象。 在Web层与Service层之间抽象的复用对象模型，极为贴近展示层，复用度不高。
5. VO（ View Object）：显示层对象，通常是Web向模板渲染引擎层传输的对象。
6. POJO（ Plain Ordinary Java Object）：在本手册中， POJO专指只有setter/getter/toString的简单类，包括DO/DTO/BO/VO等。
7. Query：数据查询对象，各层接收上层的查询请求。 注意超过2个参数的查询封装，禁止使用Map类来传输。

领域模型命名规约：
1. 数据对象：xxxDO，xxx即为数据表名。
2. 数据传输对象：xxxDTO，xxx为业务领域相关的名称。
3. 展示对象：xxxVO，xxx一般为网页名称。
4. POJO是DO/DTO/BO/VO的统称，禁止命名成xxxPOJO。

## Cacheable
报错`java.lang.Integer cannot be cast to java.lang.String`
redis中key不能将Integer强制转化为String类型。转化为字符串必须通过String.valueOf(integer) 或者Integer.toString(integer)或者Integer.toString():
```java
 redisTemplate.setKeySerializer(stringRedisSerializer());
```
如何解决？直接强改`#authorId + ''`数字转字符串
```java
@Cacheable(
            cacheManager = "redisCacheManager",
            value = "wapAuthorTopArticles",
            key = "#authorId + ''",
            unless = "#result == null"
    )
```

## Jackson
转换泛型List出现错误[`java.util.LinkedHashMap cannot be cast to com.xxx`](https://stackoverflow.com/questions/22358872/how-to-convert-linkedhashmap-to-custom-java-object/22359030)，解决方法：
```java
import com.fasterxml.jackson.databind.ObjectMapper;
private ObjectMapper mapper = new ObjectMapper();
List<ConsultantDto> myObjects = mapper.readValue(jsonInput, new TypeReference<List<ConsultantDto>>(){});
```

## Spring Bean 生命周期
http://winshu.tk/article/27

## 事物
事物的特性（ACID）
1. 原子性： 事务是最小的执行单位，不允许分割。事务的原子性确保动作要么全部完成，要么完全不起作用；
2. 一致性： 执行事务前后，数据保持一致；
3. 隔离性： 并发访问数据库时，一个用户的事物不被其他事物所干扰，各并发事务之间数据库是独立的；
4. 持久性:  一个事务被提交之后。它对数据库中数据的改变是持久的，即使数据库发生故障也不应该对其有任何影响。

## 分布式锁
