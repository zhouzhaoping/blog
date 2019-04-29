---
title: Go语言笔记
urlname: golang-tips
date: 2019-04-18 14:37:52
tags:
- 后端
- Golang
- 笔记
categories: 后端
---
这是Golang使用时的一些tips。
<!-- more -->

## channel
Go中有一句经典的话:
> Do not communicate by sharing memory; instead, share memory by communicating.

### 使用
buffer满了之后会发送阻塞
```go
ch := make(chan int, 10)
defer close(c)
ch <- v    // 发送值v到Channel ch中
v := <-ch  // 从Channel ch中接收数据，并将数据赋值给v
```
channel可以接受也可以发送，默认双向
```go
chan T          // 可以接收和发送类型为 T 的数据
chan<- float64  // 只可以用来发送 float64 类型的数据
<-chan int      // 只可以用来接收 int 类型的数据
````
receive支持 multi-valued assignment
```go
v, ok := <-ch
```
### 并发循环
```go
func main() {
    var count = 10
    var mg = make(chan struct{}, count)
    for i := 0; i < count; i++ {
        go func(i int) {
            fmt.Printf("i=%d\n", i+1)
            mg <- struct{}{}
        }(i)
    }
    for i := 0; i < count; i++ {
        <-mg
    }
    close(mg)
    return
}
```
### select选择通信
```go
import "fmt"
func fibonacci(c, quit chan int) {
	x, y := 0, 1
	for {
		select {
		case c <- x:
			x, y = y, x+y
		case <-quit:
			fmt.Println("quit")
			return
		}
	}
}
func main() {
	c := make(chan int)
	quit := make(chan int)
	go func() {
		for i := 0; i < 10; i++ {
			fmt.Println(<-c)
		}
		quit <- 0
	}()
	fibonacci(c, quit)
}
```
select可以很方便地进行timeout处理
```go
case <-time.After(time.Second * 1):
    fmt.Println("timeout 1")
```


## make 和 new
new(T) 返回 T 的指针 *T 并指向 T 的零值。  
make(T) 返回的初始化的 T，只能用于 slice，map，channel。
```go
type Foo struct {
    name string
    age  int
}

//声明初始化
var foo1 Foo
fmt.Printf("foo1 --> %#v\n ", foo1) //main.Foo{age:0, name:""}
foo1.age = 1
fmt.Println(foo1.age)

//struct literal 初始化
foo2 := Foo{}
fmt.Printf("foo2 --> %#v\n ", foo2) //main.Foo{age:0, name:""}
foo2.age = 2
fmt.Println(foo2.age)

//指针初始化
foo3 := &Foo{}
fmt.Printf("foo3 --> %#v\n ", foo3) //&main.Foo{age:0, name:""}
foo3.age = 3
fmt.Println(foo3.age)

//new 初始化
foo4 := new(Foo)
fmt.Printf("foo4 --> %#v\n ", foo4) //&main.Foo{age:0, name:""}
foo4.age = 4
fmt.Println(foo4.age)

//声明指针并用 new 初始化
var foo5 *Foo = new(Foo)
fmt.Printf("foo5 --> %#v\n ", foo5) //&main.Foo{age:0, name:""}
foo5.age = 5
fmt.Println(foo5.age)
```
底层区别： 
1. make：编译检查阶段OMAKE 节点根据参数类型的不同转换成了 OMAKESLICE、OMAKEMAP 和 OMAKECHAN 三种不同类型的节点
2. new：编译期间的 SSA 代码生成 阶段经过 callnew 函数的处理，如果请求创建的类型大小时 0，那么就会返回一个表示空指针的 zerobase 变量，在遇到其他情况时会将关键字转换成 newobject

## init函数
1. init()函数会在每个包完成初始化后自动执行，并且执行优先级比main函数高。
2. golang包初始化：
    1. 初始化导入的包（递归导入）
    2. 对包块中声明的变量进行计算和分配初始值
    3. 执行包中的init函数

3. 即使包被导入多次，初始化只需要一次。  
4. Go要求非常严格，不允许引用不使用的包。但是有时你引用包只是为了调用init函数去做一些初始化工作。此时空标识符（也就是下划线）的作用就是为了解决这个问题。
```go
import _ "image/png"
```


