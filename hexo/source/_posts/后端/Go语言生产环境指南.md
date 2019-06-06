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

## 从面向对象到Go
### 泛型
1. interface{}
2. 反射

### 函数重载

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

## 单元测试

## 压测

## 性能优化
pprof工具
1. 减少临时对象
2. 循环并发
3. 编译优化

## 线程debug

## 循环引用
