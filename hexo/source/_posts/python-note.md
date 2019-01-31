---
title: Python笔记
date: 2019-01-28 11:06:18
tags: 
- Python
- 笔记
categories: 笔记
---
这是Python的一些笔记，方便日后查询。记录不是完全的，只是一些我不知道的语言的设计方式，以及个人感觉非常特别的语言特性，还有一些有趣的代码段。

<!-- more -->

## 一、初始阶段
1. 安装py2.7，配置环境变量
2. 包管理pip：`pip list(--outdated)/install(-upgrade)/uninstall`
3. 命令行中，`ctrl+Z`结束python
4. 运行方式：命令行、IDLE、pyCharm、notepad++  
我的方式：pyCharm  

## 二、基础知识
1. 赋值：连续赋值`x=y=z=0`、多重赋值`a,b=0,1`、使用前必须赋值
2. 运算：浮点数与整型混合运算时自动转为浮点、最近运算的结果自动被赋给`_`
3. 数：整数、长整数、浮点数`52.3E-4`
4. 复数：`2.3-4.6j`or`2.3-4.6J`or`complex(0,1)`、实部虚部`.real/imag`、求模`abs(2.3-4.6j)`
5. zip函数接受任意多个（包括0个和1个）序列作为参数，返回一个tuple列表。
6. `in`和`not in`、`and`和`or`
7. 比较操作可以传递。例如`a < b == c`审核是否a小于b并且b等于c
8. list：复合类型`['spam', 100]`、支持索引切片连接、元素可被修改、通过给切片赋值，改变尺寸或者清空、长度`len(q)`、允许嵌套
9. `print a,b`子项之间自动加空格、最后加一个逗号表示不换行
10. 获得数值序列`range(begin,end,step)`、迭代的索引`for i in range(len(a))`
11. 比较按照字典序
8. 大小写敏感
9. 逻辑行（Python可见）与物理行（我所见）、分号是不必要的，如果物理行需要放多个逻辑行的时候可以使用`:`，或者使用`\`、缩进意味着新开一个语句块（缩进可以是空格或者tab）  
10. `#`是注释

## 三、运算符与表达式
1. `**`是幂、`//`是取整除、逻辑操作符`not``and``or`
2. 运算符优先级表

运算符 | 描述
----- | -----
lambda | Lambda表达式
or | 布尔或
and | 布尔与
notx | 布尔非
in, not in | 成员测试
is, is not | 同一性测试
<, <=, >, >=, !=, == | 比较
| | 按位或
^ | 按位异或
& | 按位与
<<, >> | 移位
+, - | 加减
\*, /, % | 乘法除法与取余
+x, -x | 正负号
~x | 按位翻转
\*\* | 指数
x.attribute | 属性参考
x[index] | 下标
f(arguments) | 函数调用
(expression) | 绑定或元组显示
[expression] | 列表显示
{key:datum} | 字典显示
'expression' | 字符串转换  
>1. 具有相同优先级的从左向右计算
3. 赋值运算从右向左

## 四、控制流 
1. if语句  

    ```python
    if True:
     #TODO
    elif False:
     #TODO
    else:
     #TODO
    ```

2. while语句

    ```python
    while x:
     #TODO
    else:
     #TODO
    ```
3. for语句

    ```python
    for i in range(1, 5):
     #TODO
    else:
     #TODO
    ```
4. break语句：对应的else语句块将不会执行、continue语句、pass语句什么也不做
5. 循环技巧
    ```python
    #字典循环
    for k, v in knights.iteritems():
    #序列循环
    for i, v in enumerate(['tic', 'tac', 'toe']):
    #循环两个序列
    for q, a in zip(questions, answers):
    #逆向循环
    for i in reversed(xrange(1,10,2)):
    #排序循环
    for f in sorted(set(basket)):
    ```

## 五、函数 
1.   形参、可使用全局的变量、默认参数在后面、关键参数、默认return（除非`pass`表示一个空语句或空行？那值就是`None` 

    ```python
    def function(a, b, c = 1):
    x = 1
    global y
     #do something
    return x
    y = 50
    function(1, 2)
    function(1,b = 2)
    ```
2. 函数可以赋值、默认值在函数定义作用域被解析且只被解析一次（共享，不想共享只能每次在函数内部初始化一遍）、参数中`*name`（接收元组）必须在`**name`（接收字典）之前出现
3. 参数的拆分：列表`args=[3,6] range(*args)`、字典`args={'a'=1,'b'=2} function(**args)`
4. lambda：
	
	```python
	def make_incrementor(n):
		return lambda x: x + n
	f = make_incrementor(42)
	```
2. 文档字符串DocString：第一行简介，第二行空着，之后详细描述

    ```python
    def function():
    '''This is a DocString
    Do you see that?'''
     #do something
    print function.__doc__
    ```

## 六、编码风格
*以下参考[EPE8](https://www.python.org/dev/peps/pep-0008/)*  
1. 四空格缩进，79字符限制，使用空行分隔函数和类  
2. 注释占一行，使用文档字符串  
3. 操作符两边和逗号后面留空格  
4. 统一函数名和类名`lower_case_with_underscores`  
5. 纯ASCII文本编码

## 七、模块
0. 模块就是一个包含了所有你定义函数和变量的文件，其实一个`.py`文件也是一个模块。
1. sys模块，python命令行执行带参数
    
    ```python
    import sys
    for i in sys.argv:
        print i
    print "\n\n", sys.path, "\n" 
    ```
2. `__name__`属性

    ```python
    if __name__ == '__main__':
        print 'This program is being run by itself'
    else:
        print 'I am being imported from another module'
    ```
3. 创建和调用模块
    ```python
    #filename:mymodule.py
    def sayhi():
        print 'hi to', name
    version = '1.0'    

    #filename:main.py
    import mymodule
    #from mymodule import sayhi就无需命名
    mymodule.sayhi()
    mymodule.version
    ```
这两个文件应该放在同一个目录中，或者在sys.path的目录之一  
如果使用

    ```python    
    #filename:main.py
    from mymodule import * 
    sayhi()
    version
    ```
就可以直接使用变量名了
4. `dir(mymodule)`函数返回模块定义的名称列表

## 八、数据结构
### 一、列表
1. 一些操作
	- 追加`q.append(x)`
	- 插入`q.insert(0,x)`
	- 添加另一个列表`q.extend(q2)`
	- 删除值为x的第一个元素`q.remove(x)`
	- 返回指定位置并删除`q.pop(3)`没有参数则返回最后一个
	- 第一个值为x的元素之索引`q.index(x)`
	- 出现次数`q.count(x)`
	- 排序`q.sort(x)`
	- 倒排`q.reverse('h')`
2. 堆栈用法：`append`和`pop`
3. 队列用法：collections.deque之`append`和`popleft`
4. 函数式编程：
	
    ```python
    #filter检查每元素个
    def f(x): return x % 2 != 0 and x % 3 != 0
    filter(f, range(2, 25))
    #map对每个元素做
    def cube(x): return x*x*x
    map(cube, range(1, 11))
    #map各序列元素要对应
    seq = range(8)
    def add(x, y): return x+y
    map(add, seq, seq)
    #reduce之前结果作为第一个参数叠加
    reduce(add, range(1, 11))
    #reduce第三个参数是初始值
    reduce(add, range(1, 11), 0)
	```
5. 列表推倒`[[x,x**2] for x in vec if x > 2]`、还支持嵌套
6. 删除语句`del`支持切片删除

    ```python
	a = [-1, 1, 66.25, 333, 333, 1234.5]
    del a[2]
	del a[0:2]
	del a
    ```

### 二、元组和序列
1. 用逗号构建可嵌套  
类似于列表，但是是不可变的  
还可以方便地使用在打印语句当中

    ```python
    t = ('a', 'b', 'c')
    len(t)
    print '%s is %d'%(name, age)
    ```
2. 空元组`empty = ()`、单元组`singleton = 'hello',`
3. 序列拆封`x, y, z = t`  

### 三、集合
1. 创建
    ```python
    basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
    fruit = set(basket)
    a = set('abracadabra')
    ```
2. 操作
	- 差`a - b`
	- 交`a & b`
	- 并`a | b`
	- 对称差`a ^ b`  

### 四、字典	
1. 无序的键值对，关键字可以是任意不可变类型，通常用字符串或数值。如果元组中只包含字符串和数字，它可以做为关键字，如果它直接或间接的包含了可变对象，就不能当做关键字。

    ```python
    ab = { 'a':'apple',
           'b':'banana',
         }
    len(ab)
    ab['c'] = 'hehe'#add
    del ab['c']#delete
    #output
    for name,detail in ab.items():
        print "%s ,%s"%(name,detail)
    #test
    if 'a' in ab:
    if ab.has_key('a')
    ``` 
2. 关键字-元组可以直接构造`dict([('sape', 4139), ('guido', 4127), ('jack', 4098)])`;链表推导式同理`dict([(x, x**2) for x in (2, 4, 6)])`  

### 五、引用	
对列表和其他类似的序列或者其他复杂的对象，必须使用切片操作来去的拷贝`newlist = oldlist[:]`，直接赋值只是引用到相同的对象。  

### 六、字符串
1. 字符串不可变、单引号或者双引号，中出需要转义、下一行内容是后续`\`、换行`\n`、三引号`'''`or`"""`可以指示一个多行的字符串(不需要换行，所见即所得）、前缀`r`表示原始字符串、前缀`u\U`表示Unicode字符串
2. 运算：`+`连接、`*`复制、相邻的两个字符串直接连接（只能用于两个字符串文本，表达式结果不能使用）、长度`len(strname)`、默认编码`str()`、unicode转其他`.encode('utf-8')`、其他转unicode`unicode('\xc3\xa4', 'utf-8')`
3. 切片：第几个`word[4]`、一段`word[0:2]`、默认从头尾`word[:2]`or`word[0:]`、其实还有第三个参数是步长默认为1、最后一个`word[-1]`、上下限越界会自动找交集检索越界会报错
    
## 九、面向对象
1. 创建和使用  
成员方法第一个参数的值必须是self  
`__init__`方法负责初始化，`__del__`方法负责删除  

    ```python
    class Person:
        '''this is a doc string'''
        cnt = 0
        def __init__(self, name):
            '''construct a person'''
            self.name = name
            Person.cnt += 1
        def sayhi(self):
            '''return his name'''
            return self.name
        def __del__(self)
            '''delete a person'''
            cnt -= 1
    p = Person('hehe')
    print p.sayhi()
    del p
    ```
2. 继承  
对象可以被视作是父类的实例，从而实现多态  

    ```python
    class father:
        pass
    class son(father):
        pass
    ```

## 十、输入输出
1. w写模式、r读模式、a追加模式

    ```python
    str = '''\
    test
    test
    test
    '''
    f = file('file.txt', 'w')
    f.write(str)
    f.close()
    
    f = file('file.txt')#'r' mode default
    while True:
        line = f.readline()
        if len(line) == 0:
            break
        print line
    f.close() 
    ```
2. 存储对象使用pickle或者cpickle

    ```python
    import cPickle as p
    #save
    f = file('file.data')
    p.dump(mylist, f)
    f.close()
    #read
    f = file('file.data')
    mylist = p.load()
    print mylist
    f.close()
    ```
    
## 十一、异常
1. 语句如下

    ```python
    import sys
    try:
        s = raw_input('Enter something --> ')
        f = file('file.txt')
    except EOFError:
        print '\nWhy did you do an EOF on me?'
        sys.exit()
    except ShortInputException, x:
        print 'ShortInputException:The input was of length %d, \
        was expecting at least %d' % (x.length, x.atleast)
    else:
        print 'No exception was raised.'
    finally:
        f.close()
    print 'Done'
    ```
    
## 十二、标准库
1. sys模块  
略去
2. os模块  
略去

## 十三、更多
1. 类比对象介绍中的`__init__`和`__del__`  
`__str__(self)`在使用`print`的时候会被调用  
`__lt__(self, other)`在比较`<`的时候会被调用  
`__getitem__(self, key)`在索引的时候会被调用  
`__len__(self)`在调用`len()`的时候会被调用
2. 列表综合

    ```python
    oldlist = [1, 2, 3]
    newlist = [2*i for i in oldlist if i >= 2]
    ```
3. 在函数中接收元组或者列表,在多余的参数中，分别使用`def func(*args)、def func(**args)`
4. lambda语句创建新的函数对象，并且在运行的时候返回。

    ```python
    def func(n):
        return lambda s:s*n
    myfunc = func(3)
    print myfunc('hehe')
    ```
5. `exec 'python_code'`用来执行存储在字符串或者文件中的python语句  
`eval(expresion)`用来计算存储在字符串中的python表达式
6. `assert`语句用来检验某个条件是真的
7. `repr`函数用来获取对象的规范的字符串表示

# 一些代码段
## 序列化和反序列化
```python
import pickle
name = pickle.load(open('./name.log', 'rb'))
pickle.dump(name, open('./name.log', 'wb'))
```

## 捕捉结束信号
用于程序异常退出的处理，结合序列化和反序列化，可以实现服务异常退出的断点重启。
```python
def term_sig_handler(signum, frame):
    print 'catched signal: %d' % signum
    do_something()
    sys.exit()
# catch term signal
signal.signal(signal.SIGTERM, term_sig_handler)
signal.signal(signal.SIGINT, term_sig_handler)
```
