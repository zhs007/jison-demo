# jison-demo
循序渐进的jison教程。

我本来对语法解析这块没啥兴趣的，手头上做个东西，需要自动解析protobuf协议，其实开源的实现很多，但我要能得到注释内容，没找到合适的项目，只能自己来折腾了。

nodejs项目，拉到本地后别忘了下载依赖。

```
npm install
```

具体的例子在子目录里面，每个例子都有一个jison的文件，同名的.js就是jison生成的，具体的使用看demo.js就好了。

calc
---

这就是网上能找到的最简单的calc例子了，解析纯数学运算，传入

```
(3 + 9) * 5
```

得到

```
60
```

这个是最基础的了。

calc2
---

在上面的例子上前进了一小步，传入

```
a = (3 + 9) * 5
```

得到

```
{name: 'abc', val: 60}
```

calc3
---

增加了注释的识别

```
abc = (3+9)*5 //我是注释
```

得到

```
{ name: 'abc', val: 60, comment: '//我是注释' }
```

cfgfile
---
配置文件的解析，配置文件格式如下

```
name = 'zhs007' // name
hp = 100 + 200
info = "haha"
```

输出

```
[
{name: 'name', val: 'zhs007', comment: 'name'},
{name: 'hp', val: 300},
{name: 'info', val: 'haha'}
]
```