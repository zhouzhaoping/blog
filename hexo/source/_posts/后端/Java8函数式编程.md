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
7. 无论何时，将Lambda 表达式传给Stream 上的高阶函数，都应该尽量避免副作用（式获取值而不是变量；使用局部变量，可以不使用final 关键字，但局部变量在既成事实上必须是final 的。唯一的例外是forEach 方法，它是一个终结方法。