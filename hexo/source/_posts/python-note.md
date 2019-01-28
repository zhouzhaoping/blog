---
title: Python笔记
date: 2019-01-28 11:06:18
tags: 
- Python
- 笔记
categories: 笔记
---
这是Python的一些笔记，方便日后查询。
<!-- more -->

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
