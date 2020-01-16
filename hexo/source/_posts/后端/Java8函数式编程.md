---
title: Java8函数式编程
urlname: java8-lambdas
date: 2019-12-19 16:35:04
tags:
- 后端
- Java
- 笔记
categories: 后端
---

Java8已经发布五年了，但是有的人用着JDK8但写的还是八年前发布的Java7，其中一个最大的区别就是Java8引入了函数式编程。虽说编程没有银弹，但是Java8让Java写的可以更优雅、更容易维护，确实是值得学习的。
<!-- more -->

## Lambda表达式
1. javac 根据Lambda 表达式上下文信息就能推断出参数的正确类型，可省略Lambda表达式中的所有参数类型。
2. 实现循环的优雅程度：内部迭代 > 迭代器 > for循环
3. 惰性求值操作：返回stream；及早求值操作：返回另一个值或者空。与build模式类似
4. reduce模式，reduce是max、min的通用模式
    ```java
    Object accumulator = initialValue;
    for(Object element : collection) {
    accumulator = combine(accumulator, element);
    }
    ```
5. 通过Stream 暴露集合的最大优点在于，它很好地封装了内部实现的数据结构。仅暴露一个Stream接口，用户在实际操作中无论如何使用，都不会影响内部的List或Set。
6. 高阶函数：接收函数作为参数
7. 无论何时，将Lambda 表达式传给Stream 上的高阶函数，都应该尽量**避免副作用**（式获取值而不是变量；使用局部变量，可以不使用final 关键字，但局部变量在既成事实上必须是final 的。唯一的例外是forEach 方法，它是一个终结方法。

## 类库
1. 为了减小装箱类型的性能开销，Stream 类的某些方法对基本类型和装箱类型做了区分。在Java 8 中，仅对Int、Long、Double做了特殊处理，因为它们在数值计算中用得最多，特殊处理后的系统性能提升效果最明显。
    ```java
    stream.mapToLong/mapToInt/MapToDouble
    IntSummaryStatistics trackLengthStats = album.getTracks().stream()
    .mapToInt(track -> track.getLength())
    .summaryStatistics(); // 数值统计
    ```
2. 虽然Java 在持续演进，但它一直在保持着向后二进制兼容。
3. Java8在增加Collection的stream方法之后，核心类库里的类为了兼容二进制所做的努力：ArrayList增加stream方法
4. 默认方法三定律
    ```java
    public interface Parent {
    public void message(String body);
    public default void welcome() {
    message("Parent: Hi!");
    }
    public String getLastMessage();
    }
    ```
    1. 类胜于接口。如果在继承链中有方法体或抽象的方法声明，那么就可以忽略接口中定义的方法。
    2. 子类胜于父类。如果一个接口继承了另一个接口，且两个接口都定义了一个默认方法，那么子类中定义的方法胜出。
    3. 没有规则三。如果上面两条规则不适用，子类要么需要实现该方法，要么将该方法声明为抽象方法。
5. Optional对象：使用null 代表值不存在的最大问题在于NullPointerException
    ```java
    Optional<String> a = Optional.of("a");
    if (a.isPresent())// 先调用isPresent再调用get
       a.get();    
    Optional<String> b = Optional.ofNullable(null);
    String str1 = b.orElse("default");
    String str2 = b.orElseGet(() -> {return "defualt2";});
    ```

## 高级集合类和收集器
1. 流是否保持顺序排列和集合是否有序相关
2. 
