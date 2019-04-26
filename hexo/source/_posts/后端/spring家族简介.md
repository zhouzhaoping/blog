---
title: spring家族简介
urlname: spring-springboot-springcloud
date: 2018-12-27 17:16:49
tags: Spring
categories: 后端
---
Spring框架是java后端开发的杀手级应用，当初刚接触后端开发的时候，对Spring/SpringMVC/SpringBoot/SpringCloud等概念傻傻分不清楚。下面用理论加实践的方式对Spring的家族进行研究。

<!-- more -->

## Spring
Spring是一个轻量级的控制反转（IoC）和面向切面（AOP）的容器。
### 控制反转
**控制反转（Inversion of Control，IoC）** 是一种是面向对象编程中的一种设计原则，用来减低计算机代码之间的耦合度。其基本思想是：借助于“第三方”实现具有依赖关系的对象之间的解耦。全部对象的控制权全部上缴给“第三方”IOC容器。  
反转之前：对象A依赖于对象B，那么对象A在初始化或者运行到某一点的时候，自己必须主动去创建对象B或者使用已经创建的对象B。无论是创建还是使用对象B，控制权都在自己手上。  
反转之后：由于IOC容器的加入，对象A与对象B之间失去了直接联系，所以，当对象A运行到需要对象B的时候，IOC容器会主动创建一个对象B注入到对象A需要的地方。

**依赖注入（Dependency Injection, DI）** 就是将实例变量传入到一个对象中去(Dependency injection means giving an object its instance variables)。  
解耦前
```java
public class Human {
    ...
    Father father;
    ...
    public Human() {
        father = new Father();
    }
}
```
> 解耦后
```java
public class Human {
    ...
    Father father;
    ...
    public Human(Father father) {
        this.father = father;
    }
}
```
控制反转是一种思想, 依赖注入是一种设计模式。Spring的实现方式：用XML配置的方式，其中的bean是一个对象实例，默认单例。  
1. 根据配置生成ApplicationContext，即IoC容器。  
2. 从容器中获取MovieLister的实例。  

IoC框架使用依赖注入作为实现控制反转的方式，但是控制反转还有其他的实现方式。比如**ServiceLocator**

### 面向切面
**面向切面编程（Aspect-Oriented Programming，AOP）**  
面向对象语言解决代码冗余有以下两种方法：
1. 继承抽取通用代码（纵向扩展）
2. 放入单独的类中被调用（横向扩展）

这两种方式都不是很自然，比如核心业务中总掺杂着一些不相关联的特殊业务，如日志记录，权限验证，事务控制，性能检测，错误信息检测等等，这些特殊业务可以说和核心业务没有根本上的关联而且核心业务也不关心。每个关注点与核心业务模块分离，作为单独的功能，横切几个核心业务模块，这样的做的好处是显而易见的，每份功能代码不再单独入侵到核心业务类的代码中，即核心模块只需关注自己相关的业务，当需要外围业务(日志，权限，性能监测、事务控制)时，这些外围业务会通过一种特殊的技术自动应用到核心模块中，这些关注点有个特殊的名称，叫做“横切关注点”。
```java
public class HelloWord {

    public void sayHello(){
        System.out.println("hello world !");
    }
    public static void main(String args[]){
        HelloWord helloWord =new HelloWord();
        helloWord.sayHello();
    }
}
public aspect MyAspectJDemo {
    // 定义切点
    pointcut recordLog():call(* HelloWord.sayHello(..));
    pointcut authCheck():call(* HelloWord.sayHello(..));

    before():authCheck(){
        System.out.println("sayHello方法执行前验证权限");
    }

    after():recordLog(){
        System.out.println("sayHello方法执行后记录日志");
    }
}
```
Spring AOP的内部机制（动态织入），这是与AspectJ（静态织入，一般在编译期进行）不一样的。pring AOP 并不尝试提供完整的AOP功能(即使它完全可以实现)，Spring AOP 更注重的是与Spring IOC容器的结合，并结合该优势来解决横切业务的问题。

## SpringMVC
**SpringMVC**，是Spring的一个子框架。MVC为现代web项目开发的一种很常见的模式，-简言之C（控制器Controller）将V（视图、用户客户端View）与M（模块，业务Model）分开构成了MVC ，业内常见的mvc模式的开发框架有Struts1，Struts2等。
常用的框架是SSH：Spring + struts2 + Hibernate，随着struct出现漏洞之后就演变成SSM ：Spring + SpringMVC + MyBatis。  
Spring Framework本身没有Web功能，Spring MVC使用WebApplicationContext类扩展ApplicationContext，使得拥有web功能。  
然而采用REST分格的架构可以使得前端关注界面展现，后端关注业务逻辑，分工明确，职责清晰。MVC框架逐渐被弃用。

## Spring Boot
Spring系列经过发展之后，产品变多，为了简化spring作为基础架构的项目，Spring-boot把以前的手动配置的过程自动化封装了，提供默认的配置。Spring boot对第三方技术进行了很好的封装和整合，提供了大量第三方接口，可以通过依赖自动配置，不需要XML等配置文件。按照规范去配置，让我们把精力放在开发上。  
缺点是集成度较高，使用过程中不太容易了解底层；依赖果多，启动过慢。  
[SpringBoot 究竟是如何跑起来的?](https://mp.weixin.qq.com/s?__biz=MzAwMDU1MTE1OQ==&mid=2653550562&idx=1&sn=6a2e2b48845f09f426b46a2650737a29&chksm=813a667ab64def6cd6561e641e6160d549cd11a417d3262121fab9de05e5326e2fa7ffe9dc77&scene=21#wechat_redirect)

## Spring Cloud
spring-colud是一种云端分布式架构解决方案，基于spring boot,在spring boot做较少的配置，便可成为 spring cloud 中的一个微服务。  
**关系**：SpringCloud是一个基于 Spring Boot实现的云应用开发工具; Spring Boot专注于快速、方便集成的单个微服务个体，Spring Cloud关注全局的服务治理框架。

Spring IOC/AOP > Spring > Spring Boot > Spring Cloud
