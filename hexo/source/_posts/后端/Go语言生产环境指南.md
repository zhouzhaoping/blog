---
title: Go语言生产环境指南
urlname: go-in-producation
date: 2019-04-27 00:50:02
tags:
- 后端
- Golang
categories: 后端
---

为了让go不仅仅是一个demo，我们需要Golang在生产环境中实践。这个指南是一位一年级菜鸟后端工程师踩出的各种坑，充满了血与泪；尤其是错误处理和泛型方面折腾了好久。

<!-- more -->

参考：https://draveness.me/golang-101.html

## 代码规范
代码风格：  
1. https://github.com/golang/go/wiki/CodeReviewComments  
2. https://golang.org/doc/effective_go.html  
3. https://github.com/uber-go/guide/blob/master/style.md

### 面向接口
通过接口暴露接口
```go
package post

type Service interface {
    ListPosts() ([]*Post, error)
}

type service struct {
    conn *grpc.ClientConn
}

func NewService(conn *grpc.ClientConn) Service {
    return &service{
        conn: conn,
    }
}

func (s *service) ListPosts() ([]*Post, error) {
    posts, err := s.conn.ListPosts(...)
    if err != nil {
        return []*Post{}, err
    }
    
    return posts, nil
}
```

## 目录结构
https://github.com/golang-standards/project-layout、


## 辅助工具
- 格式化：goimports = gofmt（自动格式化） + import（依赖包管理）
- 静态检查：golint + golangci-lint
- 自动化：
    - 在 GitHub 上我们可以使用 Travis CI 或者 CircleCI
    - 在 Gitlab 上我们可以使用 Gitlab CI
 
## 错误注入
gofail，例如在事物的时候可以用来测试
https://github.com/lkk2003rty/notes/blob/master/gofail.md
    
## 从面向对象到Go
Go的interface能满足90%以上的OOP需求，但又没有C++的种种陷阱；执行速度足够快。
### 泛型
Go不支持泛型，解决方法：
1. interface{}：使用 interface{}，它由值和类型组成，与 Java 中的 object 类似。不推荐使用这种方法
2. 反射
```go
func Load(result interface{}, id string) error
var result *Foo
err := Load(&result, "id")
```

### 函数重载
Go 不支持函数重载。我们推荐使用更加清晰明了的写法：
```go
func foo(a int) {}
func fooWithB(a int, b string) {}
```

### 继承
```go
type A struct { }
type B struct {
    A
}
```

### 链式调用
```go
type Query struct {
    err error
}

func (q *Query) WhereEquals(field string, val interface{}) *Query {
    if q.err != nil {
        return q
    }
    // logic that might set q.err
    return q
}

func (q *Query) GroupBy(field string) *Query {
    if q.err != nil {
        return q
    }
    // logic that might set q.err
    return q
}

func (q *Query) Execute(result inteface{}) error {
    if q.err != nil {
        return q.err
    }
    // do logic
}
var result *Foo
err := NewQuery().WhereEquals("Name", "Frank").GroupBy("Age").Execute(&result)
```

## 数据连接
### redis
连接池优化

### mongo

## rpc
库加速

## 编译优化

## 运行优化
maxprocess

## 竞态检查

## 超时控制
context

## 优雅退出

## 日志
spring生产环境中使用logback作为日志模块，golang里有没有对应的包能提供类似的日志分割的功能呢？找到一个logrus，https://www.jishuwen.com/d/2Ek8  
Hook模式  
例子：
```go
package logutil

import (
	"github.com/sirupsen/logrus"
	"github.com/lestrrat-go/file-rotatelogs"
	"github.com/rifflock/lfshook"
	"time"
	"path"
	"github.com/pkg/errors"
	"runtime"
	"strings"
	"fmt"
)

var Log *logrus.Logger

var funcpre = "code.sohuno.com/mp-recommend/mp-rec-trove/server/"
var filepre = "/root/go/src/code.sohuno.com/mp-recommend/mp-rec-trove/server/"

func init() {
	Log = logrus.New()
	Log.SetLevel(logrus.InfoLevel)
	Log.SetReportCaller(true)

	// for terminal
	Log.Formatter = &logrus.TextFormatter{
		FullTimestamp: true,
		TimestampFormat: "2006-01-02 15:04:05.000",
		CallerPrettyfier: func(f *runtime.Frame) (string, string) {
			funcname := strings.Replace(f.Function, funcpre, "", -1)
			filename := strings.Replace(f.File, filepre, "", -1)
			return fmt.Sprintf("%s()", funcname), fmt.Sprintf("%s:%d", filename, f.Line)
		},
	}

	ConfigLocalFilesystemLogger("log", "std.log", time.Hour* 24 * 30, time.Hour * 24)
}

func ConfigLocalFilesystemLogger(logPath string, logFileName string, maxAge time.Duration, rotationTime time.Duration) {
	baseLogPaht := path.Join(logPath, logFileName)
	writer, err := rotatelogs.New(
		baseLogPaht+".%Y%m%d",
		rotatelogs.WithLinkName(baseLogPaht),		// 生成软链，指向最新日志文件 todo solic
		rotatelogs.WithMaxAge(maxAge),				// 文件最大保存时间
		rotatelogs.WithRotationTime(rotationTime),	// 日志切割时间间隔
	)
	if err != nil {
		Log.Errorf("config local file system logger error. %+v", errors.WithStack(err))
	}

	// for log file
	lfHook := lfshook.NewHook(lfshook.WriterMap{
		logrus.DebugLevel: writer, // 为不同级别设置不同的输出目的
		logrus.InfoLevel:  writer,
		logrus.WarnLevel:  writer,
		logrus.ErrorLevel: writer,
		logrus.FatalLevel: writer,
		logrus.PanicLevel: writer,
	},
	&logrus.TextFormatter{
		DisableColors: true,
		TimestampFormat: "2006-01-02 15:04:05.000",
		CallerPrettyfier: func(f *runtime.Frame) (string, string) {
			funcname := strings.Replace(f.Function, funcpre, "", -1)
			filename := strings.Replace(f.File, filepre, "", -1)
			return fmt.Sprintf("%s()", funcname), fmt.Sprintf("%s:%d", filename, f.Line)
		},
	})

	var hook *HostNameHook
	Log.AddHook(hook)
	Log.AddHook(lfHook)
}
```
MyHook
```go
package logutil

import (
	"github.com/sirupsen/logrus"
	"os"
	"fmt"
	"runtime"
	"strings"
	"strconv"
)

var hostname= "HOSTNAME"

func init() {
	hostname = os.Getenv("HOSTNAME")
	fmt.Println("get hostname:", hostname)
}

type HostNameHook struct {
}

func (hook *HostNameHook) Fire(entry *logrus.Entry) error {
	entry.Data["hostname"] = hostname // so call ip
	entry.Data["goroutine_id"] = Goid() // 性能较差
	entry.Data["goroutine_num"] = runtime.NumGoroutine()
	return nil
}

func (hook *HostNameHook) Levels() []logrus.Level {
	return logrus.AllLevels
}

func Goid() int {
	var buf [64]byte
	n := runtime.Stack(buf[:], false)
	idField := strings.Fields(strings.TrimPrefix(string(buf[:n]), "goroutine "))[0]
	id, err := strconv.Atoi(idField)
	if err != nil {
		panic(fmt.Sprintf("cannot get goroutine id: %v", err))
	}
	return id
}
```
## debug
goroutine_id
https://liudanking.com/performance/golang-%E8%8E%B7%E5%8F%96-goroutine-id-%E5%AE%8C%E5%85%A8%E6%8C%87%E5%8D%97/

## 错误处理
- if err != nil { return nil, err } 
- 不是所有panic都能被捕获
- recover

## 单元测试
https://mp.weixin.qq.com/s/oD96OEv92oX0ypAYLbYFyA
- _test.go
- Suite
- BDD
- Mock 方法

## 压测

## 性能优化
pprof工具
1. 减少临时对象
2. 循环并发
3. 编译优化
go tool compile -S main.go 

## 线程debug

## 循环引用


## 提高并发度
https://blog.csdn.net/Jeanphorn/article/details/79018205
