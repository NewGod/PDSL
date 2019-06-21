# PDSL: 物理计算领域特定化语言

## 介绍

### 背景

在物理学中，物理计算是一个非常重要的方面。在物理计算中，人们需要对物理量的矢标量性以及量纲进行检测，来保证运行的正确性。

而普通的编程语言提供的往往只是数学抽象，这带来了一系列原本不需要注意的问题，提高了物理研究者的编程门槛。同时，普通的编程语言对原生数值往往忽略了一些物理公式中的常见操作(如点乘，叉乘等)。

### 目标

我们希望实现一门物理计算的领域特定化语言，这门语言使用python语法为基础，便于物理研究者上手使用，同时作为解释性语言，能够实时的进行运算。这门语法能进行实时的量纲检测，支持常见的矢量标量运算，同时能内置一定的物理函数以及物理库，方便研究者使用。

### 使用

PDSL 需要你预先安装OCAML以及Python3进行支持。

前往<https://github.com/NewGod/PDSL>下载源代码并进入代码目录，在根目录下运行`pip3 -m requirements.txt`来安装必要的依赖，接下来运行`.\ocaml.sh`来编译语法解释器，最后即可使用`.\pdsl.py inputfile`来运行该应用。

关于PDSL的更多使用方法，可以运行`.\pdsl.py --help`来获得更多的信息

### 基本框架（你来写）

## 词法

### 标识符和保留字

在PDSL中，我们定义以字母和下划线开头的，由字母数字和下划线组成的字符串为标识符，可以用于变量，物理量，单位以及函数的命名。

在标识符中，下列字符串作为保留字而不能使用：

> class def return if else in for false true and or not relation type name vector scalar cross

#### 整数与浮点数

在PDSL中，我们将整数和浮点数看作同一类型，这一类型使用如下的正则表达式来进行规约。

```Ocaml
let digit = ['0'-'9']
let int = digit+
let frac = '.' digit+
let exp = ['e' 'E']['-' '+']?digit+
let float = digit*frac+ exp?
```

#### 布尔数

PDSL也支持布尔类型，使用`true`以及`false`作为正值和负值

#### 字符串

PDSL支持python的字符串表示，如字符串`a`可以表示成`'a'`,`"a"`,`'''a'''`,`"""a"""`，参照[python中对于字符串的表示](https://docs.python.org/3/reference/lexical_analysis.html#other-tokens)，我们规约如下：

```Ocaml
let longbyteschar  =  [^ '\\']
let bytesescapeseq =  '\\' _
let longbytesitem  =  longbyteschar | bytesescapeseq
let shortbytes     =  (['\'' '\"'])([^ '\'' '\"' '\r' '\n']|bytesescapeseq)*? (['\'' '\"'])
let longbytes      =  "'''" longbytesitem*? "'''" | "\"\"\"" longbytesitem*? "\"\"\""
```

## 语法（交给你了）

### 表达式

#### 基本类型

#### 数组

#### 标识符

#### 一元运算

#### 二元运算

#### 三元运算

#### 函数调用

#### 表达式列表

### 语句

#### 表达式语句

#### 条件语句

#### 循环语句

#### 注释

#### 函数声明

## 后端

### 物理量定义的管理及表示

我们将对一个物理量的定义拆开成若干个python语句：

```python
def add_var(name: str, base: Optional[str], vector=False): # 添加物理量及其基本单位
def add_subunit(base: str, sub: str, rate: float):
def add_relation(name: str, relation: Dict[str, float]):
```

同时我们会对该物理量的关系进行检查，保证所有的物理量定义的关系集合满足DAG（有向无环图），并记录所有无依赖关系的单位为基本物理量。当我们接收到一个变量的时候，我们将其单位表示为一个由基本物理量组成的表示，便于后面的比较和运算。在输出的时候再将其编码回去。

### 物理量的表示

在物理量的表示上，我们定义了一个结构体`PhyVar`用来表示所有的物理变量，其接口定义如下：
```python
class PhyVar:
    def __init__(self, val: Union[float, List[float]], unit: Unit, is_ori=False):
```

其输入的参数分别为向量或标量的值，单位，以及其初始化为来自parser或者是来自自身。

我们在这个结构体内实现了比较函数，运算函数，类型转换函数，以及格式化函数等辅助函数。

```python
    # 比较函数
    def __eq__(self, var: 'PhyVar') -> bool:
    def __gt__(self, var: 'PhyVar') -> bool:
    def __lt__(self, var: 'PhyVar') -> bool:
    def __ge__(self, var: 'PhyVar') -> bool:
    def __le__(self, var: 'PhyVar') -> bool:
    # 运算函数
    def __add__(self, var: 'PhyVar') -> 'PhyVar':
    def __neg__(self) -> 'PhyVar':
    def __sub__(self, var: 'PhyVar') -> 'PhyVar':
    def __mul__(self, var: Union['PhyVar', float]) -> 'PhyVar':
    def __rmul__(self, var: Union['PhyVar', float]) -> 'PhyVar':
    @classmethod
    def cross(cls, a: 'PhyVar', var: 'PhyVar') -> 'PhyVar':
    def __truediv__(self, var: 'PhyVar') -> 'PhyVar':
    #类型转换函数
    def __str__(self) -> str:
    def __float__(self) -> float:
    def __int__(self) -> int:
    #其他内部函数
    def format(self, unit: Unit) -> str:
    @property
    def len(self) -> float: # 获得向量长度
    def get_dim(self) -> int: # 获得向量维数
    def __setitem__(self, key: int, value: float): # 设置向量某一维的大小
    def __getitem__(self, key) -> 'PhyVar': # 获得向量的一个切片
```

#### 错误控制与警告

在物理量的运算和比较过程中，如果出现矢量运算同向量运算混合，或者单位出现冲突，我们应该抛出相应的警告。同时，由于python的变量类型可以改变，而在物理运算中往往单一变量之会表示同一物理量，同时会保持其矢向量性，我们希望保持这两种性质。因此在变量赋值时我们将会检查其赋值前与赋值之后的单位以及矢向量性，如果不同则抛出一个警告。

## 前后端结合（这个得改个名字）

最后我们写了一个简单python用来结合前端和后端，我们使用管道将文件输入到parser，然后将前端的输出交给后端执行。

同时我们也尝试实现一个交互模式（即实时解析输入并执行）但是由于python的交互模式无法使用管道进行输入重定向，所以无法实现。

## 工程维护和测试

我们在工程的维护和测试上，我们使用了比较自动化的管理过程，在`python-ci.py`中展示了我们如何利用自动化工具来维护我们的代码，并对代码进行正确性测试

### 代码管理

我们使用了git以及github来进行管理和托管我们的代码，利用issue来记录我们在编码过程中遇到的问题，并进行分工。同时映入代码审查机制，通过设置保证不能直接向主分支进行提交，其他分支合并时一定要通过其他人的代码审查来减少错误，保证主分支的稳定性。

### 代码规范

在代码规范上，我们使用了autopep8这个代码风格自动化工具来检查我们的代码，保证我们代码的可读性。同时使用了pytype对python代码进行了静态检查，保证尽量减少在运行时出现的错误。

### 单元测试

我们使用了python的unittest模块来编写测试模块并进行单元测试，保证我们单一模块的准确性。

### 系统测试

我们实现了几个程序，用来验证我们整个应用的输出是否合法，是否有相应的行为。

## TODO (把ppt上的东西写下来)

## 分工 （帮忙写清楚一点）

### 庄博尔

词法分析的设计和实现

后端部分python代码的编写

报告

### 靳立晨

语法分析的设计和实现

使用ocaml完成将输入翻译成中间语言

报告

## 对其他人的评价（交给你了，我这边的感觉就是大家做的都很棒（自闭了）（当然了除了黄厚均= =））

### Lisp Torch

### MiniC 的编译与反编译

### 解释性C语言的实现

### Chips代码阅读及分析

### 类C的命令式语言 Cm

### LaJVM

### 全局范围分析