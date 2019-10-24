---
title: hexo进阶——内嵌展示
urlname: hexo-content-show
date: 2019-10-21 15:08:08
tags: 
- 前端
- 个人网站
categories: 前端
---

 在上一篇文章[hexo进阶——配置优化及插件使用](http://blog.zhouzhaoping.com/Frontend/hexo-config/)里，我们配置了hexo的各种配置，优化了内容展示；同时还介绍了各种插件的使用，例如评论、点赞、统计访问量等。接下来还得继续折腾，我们想把一些写好的html嵌入到文章中应该怎么操作呢？尤其是想插入echart这样的动态数据。

<!-- more -->

## 图片使用
### 公式图片
在markdown里面直接加上如下的一段
```html
<br><img src="http://latex.codecogs.com/gif.latex?J(\theta)=\frac1{2m}(X\theta-Y)^T(X\theta-Y)=\frac1{2m}(\theta^TX^T-Y^T)(X\theta-Y)"/>
```
### 图床

#### 本地
1. 图片放在source/images中
2. 文章内使用方式：`![](/images/image.jpg)`

#### github
也可以选择github的issue作为图床
1. 创建一个新issue
2. 拖拽上传图片，一次可以上传多张
2. 上传完 issue 之后，就可以直接在图片上右键复制图片URL

#### 七牛云
选择七牛云图床，实名认证后有10G免费空间。一般3个工作日内会审批  
1. 打开对象存储，新建存储空间
2. 点开刚才新建的空间，在内容管理里上传文件
3. 把外链域名粘贴到markdown里

***2019.9.18七牛云的羊毛不能再撸了，要求使用备案的域名才能使用图床，于是直接使用hexo的本地目录先作为暂时解决方案***

### https://imgur.com/


## 表格
### markdown表格
```markdown
  | 资产 | 负债 | 股东权益 | 
  | ----- | ------ | ------ |
 | 在建工程 | 贷款 | 股本 | 
```

### 插入html代码
使用raw是为了避免渲染时插入br标签
```html
    {% raw %}  
    <table>
    <thead>
    <tr>
    <th>资产</th>
    <th>负债</th>
    <th>股东权益</th>
    </tr>
    </thead>
    <tbody><tr>
    <td>在建工程</td>
    <td>贷款</td>
    <td>股本</td>
    </tr>
    </tbody></table>
    {% endraw %}  
```
[markdown表格转html](https://marked.js.org/demo)


## 创建自定义网页
### 插入 Swig 代码
如果需要在页面内插入 Swig 代码，包括原生 HTML 代码，JavaScript 脚本等，可以通过 raw 标签来禁止 Markdown引擎渲染标签内的内容。语法如下：
```
{% raw %}
content
{% endraw %}
```
该标签通常用于在页面内引入三方脚本实现特殊功能，尤其是当该三方脚本尚无相关 hexo 插件支持的时候，可以通过写原生 Web 页面的形式引入脚本并编写实现逻辑。

### 新开页面
在 Hexo\source 目录下创建一个文件夹，文件夹名称任意，将 Html 文件放置于此文件夹，并重命名为 index.html（不用index也可以，不过访问要使用完全路径）。接下来有两种方法让它不被渲染：
1. 在Hexo 目录下的_config.yml 文件，找到 skip_render，添加需要禁止渲染的文件
2. 用编辑器打开 Hexo\source 创建的文件夹中的 index.html 文件，在开头添加如下代码即可

```markdown

---
layout: false
---
```
这是我的[例子](/demo/hehe.html)。以后简历、静态的页面就可以利用hexo这么挂载出去了。

## Echarts
前段时间看了[echarts](https://www.echartsjs.com/en/index.html)非常酷，是百度团队出品的一个可视化制图开源工具，特别适合展示金融数据。后来使用[pyecharts](https://pyecharts.org)生成了很多统计的html页面，但是可惜没办法在博客中使用它。

```bash
npm install hexo-tag-echarts3 --save
```

之后在文章内使用 ECharts 的 tag 就可以了：
```markdown
{% echarts 400 '85%' %}
\\TODO option goes here
{% endecharts %}
```

{% echarts 400 '85%' %}
option = {
    xAxis: {
        type: 'category',
        data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    },
    yAxis: {
        type: 'value'
    },
    series: [{
        data: [820, 932, 901, 934, 1290, 1330, 1320],
        type: 'line'
    }]
};
{% endecharts %}

## Tab 标签
使用方式
```markdown
{% tabs [Unique name], [index] %}
<!-- tab [Tab caption]@[icon] -->
Any content (support inline tags too).
<!-- endtab -->
{% endtabs %}
```
说明  
1. Unique name 为每个标签页组唯一的名称
2. index 为初始激活的标签页
3. Tab caption 为标签页名称，不指定时为所属标签页组名称加索引
4. icon 为 Font awesome图标，可选。

注意：tab里面放代码块要使用下面的语法
```markdown
{% codeblock lang:bash %}
# ps -ef
{% endcodeblock %}
```

