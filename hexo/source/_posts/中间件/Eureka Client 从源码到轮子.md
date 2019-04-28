---
title: Eureka Client 从源码到轮子
urlname: eureka-client-for-golang
date: 2018-12-18 14:49:24
tags:
- 中间件
- Golang
- Eureka
- Spring
categories: 中间件
---
最近在给公司的内容服务做性能优化，经过调研选择用go语言重构，但是由于go语言下没有一个好用的EurekaClient，所以自己造了一个轮子[eurekaclient](https://github.com/zhouzhaoping/eurekaclient)

<!-- more -->

## 什么是Eureka
服务注册和发现是微服务体系的一个重要的部分，Eureka就是Netflix开源的一款提供服务注册和发现的产品，并且提供了相应的Java客户端。此外Spring Cloud Zookeeper、Spring Cloud Consul和Spring Cloud etcd都可以用于服务治理或服务发现。
下图是Eureka的基本架构
![Alt text](http://pjwvhuyq6.bkt.clouddn.com/eureka-architecture-overview.png)

如上图Eureka有三种角色:
1. Eureka Server:注册发现中心的实例
2. Service Provider:服务的提供者，需要经自己的服务信息注册到服务中心
3. Service Consumer:服务的消费者，从服务中心获得已注册的服务信息，然后再进行服务调用

而在集群模式下，不止有一个Eureka Server。之间会进行注册服务的同步，保证状态一致  
这三种角色之间的通信主要依赖三种组件：
1. Eureka Server:保存服务信息，接受client端的各种修改服务信息的请求，剔除失效服务
2. Eureka Client for Provider:服务提供者进行服务注册、续约、下线
3. Eureka Client for Consumer:服务消费者获取注册信息

![Alt text](https://raw.githubusercontent.com/Netflix/eureka/master/images/eureka_architecture.png)

## Eureka REST 操作
参考[官方wiki](https://github.com/Netflix/eureka/wiki/Eureka-REST-operations)  
基本可以实现eurekaclient的通信
### Eureka Client for Provider
1. Register：服务启动后发送json格式的注册信息
2. Renew：每三十秒发送一次心跳
3. Cancel：服务结束后发送取消信息  

### Eureka Client for Consumer
1. Fetch Registries：向服务中心查看可用的服务（spring里真正的实现有缓存机制和增量查询）  

在具体实现的时候这两种client可以合并成一种，功能用不同函数实现

## 设计细节
根据官方的wiki，能够完成基本的网络交互，但是一些细节并没有给出，需要在源码里仔细阅读并实现。主要是Eureka Client for Consumer的例如多个服务中心的选择，多个服务的选择，缓存的设计。

### 缓存与更新
查看eureka的源码，发现client端的服务列表是有缓存机制和增量更新的，每3min进行一次服务列表的更新。  
而在具体实现里我只实现了缓存机制，并没有考虑增量更新。

### 重试
我们知道client会在后面的生命周期中注册，保持心跳，更新状态信息以及注销自身。通过阅读源码，发现在装载所有server url之后，client会打乱顺序，并且将自身zone的所在的url排到数组的前面，每一次进行网络请求，都选取第一个地址，如果失败就顺次尝试。  
同时client有一种隔离机制，对于网络通信错误的url，会进入隔离区，下次进行通信不会使用。但这种隔离并不是永久的，当达到某一个阈值后，这个隔离区会清空。  
而在具体实现里我只实现了顺次尝试，后续可以考虑网络延时的概率优化（比如提高延时比较低的eureka server的选择概率），我觉得这个策略可能比顺次尝试+隔离的策略要好一些，主要浪费时间的点是概率的计算。

### 负载均衡
eureka的服务发现中所实现的负载均衡是在client端完成的，具体使用了ribbon算法，简单来说其实就是轮询策略，每次选择下一个服务器。在我这边的具体实现变成了RandomRule随机策略。

## 代码
具体代码可以到github上查看[https://github.com/zhouzhaoping/eurekaclient](https://github.com/zhouzhaoping/eurekaclient)
```go
package eurekaclient

import (
	"github.com/twinj/uuid"
	"strings"
	"fmt"
	"time"
	"log"
	"encoding/json"
	"net"
	"os"
	"os/signal"
	"syscall"
	"math/rand"
	"strconv"
	"sync"
)

var regHostName = `dmo-${appName}-${uuid}`
var regInstanceId = `${hostName}:${appName}:${port}`

var regTpl =`{
  "instance": {
	"instanceId":"${instanceId}",
    "hostName":"${hostName}",
    "app":"${appName}",
	"ipAddr":"${ipAddress}",
    "vipAddress":"${appName}",
	"secureVipAddress":"${appName}",
    "status":"UP",
    "port": {
      "$":${port},
      "@enabled": true
    },
    "securePort": {
      "$":${securePort},
      "@enabled": false
    },
    "homePageUrl" : "http://${hostName}:${port}/",
    "statusPageUrl": "http://${hostName}:${port}/info",
    "healthCheckUrl": "http://${hostName}:${port}/health",
    "dataCenterInfo" : {
      "@class":"com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo",
      "name": "MyOwn"
    },
    "metadata": {
      "management.port": ${port}
    }
  }
}`


type EurekaClient struct {
	urlCur int
	discoveryServerUrls []string
	appName string

	// for Service server
	instanceId string

	// for Service client
	mu      sync.Mutex
	instances []EurekaInstance
}

func NewEurekaClient (eurekaUrls []string, appName string )*EurekaClient{
	return &EurekaClient{
		urlCur : 0,
		discoveryServerUrls: eurekaUrls,
		appName : appName,
		instances:nil,
	}
}

/**
 * Tools for update
 */
func (e *EurekaClient) StartUpdateInstance() { //todo sync
	e.GetServiceInstances()
	go func(){
		time.Sleep(30*time.Second)
		fmt.Println("Update instance...")
		e.GetServiceInstances()
	}()
}

/**
 * Register the application at the default eurekaUrl.
 */
func (e *EurekaClient) Register(port string, securePort string) {

	hostName, err := os.Hostname()
	if err != nil {
		hostName := string(regHostName)
		hostName = strings.Replace(hostName, "${appName}", e.appName, -1)
		hostName = strings.Replace(hostName, "${uuid}",getUUID(),-1)
	}

	e.instanceId = string(regInstanceId)
	e.instanceId = strings.Replace(e.instanceId, "${hostName}",hostName, -1)
	e.instanceId = strings.Replace(e.instanceId, "${appName}", e.appName, -1)
	e.instanceId = strings.Replace(e.instanceId, "${port}", port, -1)

	tpl := string(regTpl)
	tpl = strings.Replace(tpl, "${instanceId}",e.instanceId, -1)
	tpl = strings.Replace(tpl, "${hostName}",hostName, -1)
	tpl = strings.Replace(tpl, "${ipAddress}", getLocalIP(), -1)
	tpl = strings.Replace(tpl, "${port}", port, -1)
	tpl = strings.Replace(tpl, "${securePort}", securePort, -1)
	tpl = strings.Replace(tpl, "${appName}", e.appName, -1)

	// Register.
	registerAction := HttpAction{
		Url:         "${discoveryServerUrl}" + "/eureka/apps/" + e.appName,
		Method:      "POST",
		ContentType: "application/json;charset=UTF-8",
		Body:        tpl,
	}

	var result bool
	for _,url := range e.discoveryServerUrls {
		registerAction.Url = url + "/eureka/apps/" + e.appName
		result = doHttpRequest(registerAction)
		if result {
			fmt.Println("Registration OK")
			e.handleSigterm()
			go e.startHeartbeat()
			break
		} else {
			fmt.Println("Registration attempt of " + e.appName + " failed...")
			time.Sleep(time.Second * 5)
		}
	}

}

/**
 * Given the supplied appName, this func queries the Eureka API for instances of the appName and returns
 * them as a EurekaApplication struct.
 */
func (e *EurekaClient) GetServiceInstances() (error) {

	var m EurekaServiceResponse
	fmt.Println("Querying eureka for instances of " + e.appName + " at: " + "${discoveryServerUrl}" + "/eureka/apps/" + e.appName)
	queryAction := HttpAction{
		Url:         "${discoveryServerUrl}" + "/eureka/apps/" + e.appName,
		Method:      "GET",
		Accept:      "application/json;charset=UTF-8",
		ContentType: "application/json;charset=UTF-8",
	}
	var err error
	var bytes []byte
	for _,url := range e.discoveryServerUrls {
		queryAction.Url = url + "/eureka/apps/" + e.appName
		log.Println("Doing queryAction using URL: " + queryAction.Url)
		bytes, err = executeQuery(queryAction)
		if err != nil {
			continue
		} else {
			fmt.Println("Got instances response from Eureka:\n" + string(bytes))
			err = json.Unmarshal(bytes, &m)
			if err != nil {
				fmt.Println("Problem parsing JSON response from Eureka: " + err.Error())
				continue
			}
			e.mu.Lock()
			e.instances = m.Application.Instance
			e.mu.Unlock()
			return err
		}
	}
	e.mu.Lock()
	e.instances = nil
	e.mu.Unlock()
	return err
}

// unuse
func (e *EurekaClient) GetServices() ([]EurekaApplication, error) {
	var m EurekaApplicationsRootResponse
	fmt.Println("Querying eureka for services at: " + "${discoveryServerUrl}"+ "/eureka/apps")
	queryAction := HttpAction{
		Url:        "${discoveryServerUrl}" + "/eureka/apps",
		Method:      "GET",
		Accept:      "application/json;charset=UTF-8",
		ContentType: "application/json;charset=UTF-8",
	}

	var err error
	var bytes []byte
	for _,url := range e.discoveryServerUrls {
		queryAction.Url = url + "/eureka/apps"
		log.Println("Doing queryAction using URL: " + queryAction.Url)
		bytes, err = executeQuery(queryAction)
		if err != nil {
			continue
		} else {
			fmt.Println("Got services response from Eureka:\n" + string(bytes))
			err = json.Unmarshal(bytes, &m)
			if err != nil {
				fmt.Println("Problem parsing JSON response from Eureka: " + err.Error())
				continue
			}
			return m.Resp.Applications, nil
		}
	}
	return nil, err
}

func (e *EurekaClient)GetRandomServerAddress() string {
	rand.Seed(time.Now().Unix())

	e.mu.Lock()
	if e.instances == nil {
		e.mu.Unlock()
		fmt.Println("can not get address")
		return ""
	}
	i := rand.Intn(len(e.instances))
	for _, ins := range(e.instances){
		address := ins.IpAddr + ":" + strconv.Itoa(ins.Port.Port)
		fmt.Println(address)
	}
	address := e.instances[i].IpAddr + ":" + strconv.Itoa(e.instances[i].Port.Port)
	fmt.Println("choice address:" + address + ", hostname:" +  e.instances[i].HostName)
	e.mu.Unlock()

	return address
}

// Start as goroutine, will loop indefinitely until application exits.
func (e *EurekaClient)startHeartbeat() {
	for {
		time.Sleep(time.Second * 30)
		e.heartbeat()
	}
}

func (e *EurekaClient)heartbeat() {

	heartbeatAction := HttpAction{
		Url:         "${discoveryServerUrl}" + "/eureka/apps/" + e.appName + "/" + e.instanceId,
		Method:      "PUT",
		ContentType: "application/json;charset=UTF-8",
	}

	var result bool
	for _,url := range e.discoveryServerUrls {
		heartbeatAction.Url = url + "/eureka/apps/" + e.appName + "/" + e.instanceId
		result = doHttpRequest(heartbeatAction)
		if result {
			fmt.Println("Issuing heartbeat to " + heartbeatAction.Url)
			break
		} else {
			fmt.Println("Retry heartbeat...")
		}
	}
}

func (e *EurekaClient)deregister() {

	fmt.Println("Trying to deregister application " + e.appName + "...")
	// Deregister
	deregisterAction := HttpAction{
		Url:         "${discoveryServerUrl}" + "/eureka/apps/" + e.appName + "/" + e.instanceId,
		ContentType: "application/json;charset=UTF-8",
		Method:      "DELETE",
	}
	var result bool
	for _,url := range e.discoveryServerUrls {
		deregisterAction.Url = url + "/eureka/apps/" + e.appName + "/" + e.instanceId
		result = doHttpRequest(deregisterAction)
		if result {
			fmt.Println("Deregistered application " + e.appName + ", exiting. Check Eureka...")
			break
		} else {
			fmt.Println("Retry deregister...")
		}
	}
}

// get Intranet Ip
func getLocalIP() string {
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		return ""
	}
	/*for _, address := range addrs {
		fmt.Println("get ip:",address.String(), address.Network())
	}*/
	for _, address := range addrs {
		// check the address type and if it is not a loopback the display it

		if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				return ipnet.IP.String()
			}
		}
	}
	panic("Unable to determine local IP address (non loopback). Exiting.")
}

func getUUID() string {
	return uuid.NewV4().String()
}

func (e *EurekaClient)handleSigterm() {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	signal.Notify(c, syscall.SIGTERM)
	go func() {
		<-c
		e.deregister()
		os.Exit(1)
	}()
}
```
使用方式
```go
// Service server
e := eurekaclient.NewEurekaClient([]string{"http://123.45.45.31:1234","http://10.16.58.219:9998","http://10.18.37.71:9998"},"zzp-go-test")
e.Register("6565","443")

// Service client
e.StartUpdateInstance()
for i:= 0; i <10; i++ {
	e.GetRandomServerAddress()
}
```
