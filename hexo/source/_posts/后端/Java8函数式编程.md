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
