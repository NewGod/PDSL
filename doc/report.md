# PDSL: 物理计算领域特定化语言

## 一、介绍

### 1. 背景

在物理计算中，人们需要对物理量的矢标量性以及量纲进行检测，来保证运行的正确性；而普通的编程语言提供的往往只是数学抽象，这带来了一系列原本不需要注意的问题，提高了物理研究者的编程门槛。同时，普通的编程语言对原生数值往往忽略了一些物理公式中的常见操作(如点乘，叉乘等)。

因此，能够对物理世界的计算提供更好抽象的高级语言是大有裨益的。事实上，Frink语言就支持了上千种物理单位的检查与换算，如下面这个例子：

~~~Frink
circ = 9.25 in
mass = 5.25 oz
circ = new interval[9, 9 + 1/4] inches
mass = new interval[5, 5 + 1/4] ounces
radius[circ] := circ/(2 pi)
volume[radius] := 4/3 pi radius^3
density[mass, volume] := mass / volume
~~~

Frink支持了计量单位后缀于数字的语法，可以更容易地让用户“打物理草稿”。

### 2. 目标

受到Frink语言的启发，我们希望实现一门物理计算的领域特定化语言(PDSL)：

- 这门语言使用python语法为基础，便于物理研究者上手使用
- 作为解释性语言，能够实时的进行运算
- 实时的量纲检测与换算
- 支持常见的矢量标量运算
- 内置一定的物理函数以及物理库，方便研究者使用

另外，我们希望PDSL和Frink相比能够更加灵活：

- 不同于Frink写好的内置计量单位，我们是支持自定义物理量类型和量纲关系的，这样给用户提供了DIY的空间，而且**单位相同意义却不同**的物理量(比如距离/位移，功/能量)也可以通过这种定义方式加以明晰。
- 当然，本来应该“写死”的物理量单位也可以通过我们设计的语法写成标准库。

最后，由于Frink等语言都是闭源的，我们也希望在这个project的过程中初步实现出一个开源的物理计算语言，各种细节也方便未来的改进。

### 3. 使用

PDSL 需要预先安装OCAML以及Python3进行支持。

前往<https://github.com/NewGod/PDSL>下载源代码并进入代码目录，在根目录下运行`pip3 -m requirements.txt`来安装必要的依赖，接下来运行`.\ocaml.sh`来编译语法解释器，最后即可使用`.\pdsl.py inputfile`来运行该应用。

关于PDSL的更多使用方法，可以运行`.\pdsl.py --help`来获得更多的信息

### 4. 基本框架

整体架构如下图所示：

![1561142021683](C:\Users\superbluecat\AppData\Roaming\Typora\typora-user-images\1561142021683.png)

- **前端**是基于Ocaml语言的Lex-Yacc架构，读入字符串通过SDT生成python语言的中间语句
- 一个**桥接模块**将Ocaml分析器生成的IR递交给后端
- **后端**用python实现，将中间语句进行解释执行，这里也实现一部分更复杂的语义功能
- 结果被递交回桥接模块并输出



## 二、实现细节

### 1. 词法

#### 标识符和保留字

在PDSL中，我们定义以字母和下划线开头的，由字母数字和下划线组成的字符串为标识符，可以用于变量，物理量，单位以及函数的命名。

在标识符中，下列字符串作为保留字而不能使用：

> class def return if else in for false true and or not relation type name vector scalar cross

根据Lex的匹配规则，保留字应在标识符的规则前面。

#### 整数与浮点数

在PDSL中，我们将整数和浮点数看作同一类型，这一类型使用如下的正则表达式。

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

PDSL支持python的字符串表示，如字符串`a`可以表示成`'a'`,`"a"`,`'''a'''`,`"""a"""`，也要考虑转义字符。参照[python中对于字符串的表示](https://docs.python.org/3/reference/lexical_analysis.html#other-tokens)，详细定义如下：

```Ocaml
let longbyteschar  =  [^ '\\']
let bytesescapeseq =  '\\' _
let longbytesitem  =  longbyteschar | bytesescapeseq
let shortbytes     =  (['\'' '\"'])([^ '\'' '\"' '\r' '\n']|bytesescapeseq)*? (['\'' '\"'])
let longbytes      =  "'''" longbytesitem*? "'''" | "\"\"\"" longbytesitem*? "\"\"\""
```

### 2. 语法

语法分析部分内容较多，我们选择和PDSL的feature最相关的部分进行介绍(为了便于观看，略去部分SDT，部分符号和源码相比也做了些修改)。

#### （1）物理量类型定义

定义物理量时，它的计量单位可以有特定的名字也可以没有；可以是复合单位也可以是基本单位；可以有多个非标准单位的换算也可以没有。最特殊的情况——class Empty {}，什么都没有的空物理量也是允许的。因此，我们这里把文法设计成如下：

~~~ocaml
class_def 
	: 
	basic_class_def
	maybe_name
	maybe_relation 
	subunit_list
	RCP
	;
maybe_name:
	empty
	| NAME ASSIGN IDENT BOUNDARY
	};

maybe_relation:
	empty
	| RELATION ASSIGN relation_exp BOUNDARY
	;
subunit_list:
	empty
	| NUM A = NUM B ; subunit_list
	;
~~~

name = blabla, relation = blabla, 1kg = 1000g 这样的语句都是可选的；对应于maybe_name, maybe_relation, 分析器会根据语句的有/无采取不同的行动，生成不同的中间python语句。但是无论如何，根据标识符注册新物理量的IR都是必不可少的。

#### （2）量纲表达式定义

这样的量纲表达式，我们将其定义为标识符的常数次幂的乘/除法构成的式子，比如 (kg * m) / s**2就是一个正确的量纲表达式。文法定义如下：

~~~ocaml
relation_exp
	: relation_exp MULTI relation
	| relation_exp DIV relation
	| relation
	;

relation:
	 LP relation_exp RP 
	| relation POWER ct2
	| IDENT
	;
single_const_exp:
	ct1 PLUS single_const_exp
	| ct2 MINUS single_const_exp
	| ct1
ct1:
	ct2 MULTI ct1
	| ct2 DIV ct1
	| ct2
ct2:
	LP single_const_exp RP
	| MINUS ct2
	| NUM
~~~

我们可以支持s**(1+1)这样的写法，并且利用Ocaml的Map数据结构来维护当前量纲表达式的{单位：指数}的关系，可以在分析过程中完成一个无冗余的{单位：指数}的计算，这样为python生成的Unit Dict就是已经整理到最简的。

#### （3）表达式中带单位的量的表示

我们在这一步发现一个关键问题：自定义单位和变量标识符的混淆。为了解决这个问题，我们引入中括号把表达式中的量纲表达式隔离开来，比如 1 [N / s]。

#### （4）矢量和标量的统一

虽然语义上要区分矢量和标量，但是在语法上，在对物理计算的抽象上，二者地位相等。所以在语法树中，1 [N]和 [1,2,3] [N] 都属于参与运算的基本常量，它们是平等的。

#### （5）表达式层次优先级的组织

我们发现后缀单位的语法会和其他的算符间产生几十个移进/规约冲突，这是由于后缀一个单位组合应该被视为对表达式的单目运算符，应当列入优先级的考虑中。

~~~ocaml
		%right ASSIGN
        %left LOG_AND
        %left LOG_OR 
        %nonassoc ULOG_NOT
        %nonassoc NEQ EQ
        %nonassoc LEQ GEQ LE GT       /* lowest precedence */
        %left PLUS MINUS        /* lowest precedence */
        %left MOD MULTI DIV         /* medium precedence */
        %left CROSS
        %nonassoc UMINUS 
        %left UFUNC DOT
        %nonassoc UUNIT
~~~

#### (6) 其他

在块缩进和分隔符上我们采用了类C++的大括号/分号风格。因此转化为python语句时要实时维护缩进数。

~~~ocaml
let indent_cnt = ref 0;;
let curr_idtstr = ref "";;
lcp_addident:
	LCP
	{
		indent_cnt := indent_cnt.contents + 1;
		curr_idtstr := curr_idtstr.contents ^ "\t";
	};

rcp_subident:
	RCP
	{
		indent_cnt := indent_cnt.contents - 1;
		if indent_cnt.contents < 0 
		then Printf.eprintf "bad indent"
		else 
		curr_idtstr := String.sub curr_idtstr.contents 1 indent_cnt.contents
	};
~~~

### 3. 后端

#### 物理量定义的管理及表示

我们将对一个物理量的定义拆开成若干个python语句：

```python
def add_var(name: str, base: Optional[str], vector=False): # 添加物理量及其基本单位
def add_subunit(base: str, sub: str, rate: float):
def add_relation(name: str, relation: Dict[str, float]):
```

同时我们会对该物理量的关系进行检查，保证所有的物理量定义的关系集合满足DAG（有向无环图），并记录所有无依赖关系的单位为基本物理量。接收到一个变量的时候，我们将其单位表示为一个由基本物理量组成的表示，便于后面的比较和运算。在输出的时候再将其编码回去。

#### 物理量的表示

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

在物理量的运算和比较过程中，如果出现不相容的运算(维数不对等，标量参与叉乘)，或者单位出现冲突，我们应该抛出相应的警告。同时，由于python的变量类型可以改变，而在物理运算中往往单一变量之会表示同一物理量，同时会保持其向量性，我们希望保持这两种性质。因此在变量赋值时我们将会检查其赋值前与赋值之后的单位以及向量性，如果不同则抛出一个警告。

### 4. 桥接模块

最后我们写了一个简单python脚本用来桥接前端和后端，使用管道将文件输入到parser，然后将前端的输出交给后端执行。

同时我们也尝试实现一个交互模式（即实时解析输入并执行）但是由于python的交互模式无法使用管道进行输入重定向，所以暂时没有实现。

### 5. 工程维护和测试

我们在工程的维护和测试上使用了比较自动化的管理过程，在`python-ci.py`中展示了如何利用自动化工具来维护我们的代码，并对代码进行正确性测试

#### 代码管理

我们使用了git以及github来进行管理和托管我们的代码，利用issue来记录我们在编码过程中遇到的问题，并进行分工。同时映入代码审查机制，通过设置保证不能直接向主分支进行提交，其他分支合并时一定要通过其他人的代码审查来减少错误，保证主分支的稳定性。

#### 代码规范

在代码规范上，我们使用了autopep8这个代码风格自动化工具来检查我们的代码，保证我们代码的可读性。同时使用了pytype对python代码进行了静态检查，保证尽量减少在运行时出现的错误。而不同于python，Ocaml是强静态的语言，自带很强

#### 单元测试

我们使用了python的unittest模块来编写测试模块并进行单元测试，保证我们单一模块的准确性。

#### 样例测试

我们用自己定义的PDSL语言写了几个简易的脚本，把它们输入整个搭好的系统，并且检查输出是否符合预期。在类型定义、算术运算、逻辑运算、分支、循环、矢量标量运算等简单样例下测试通过。

## 三、TODO

- 更多的test case

- 标准库的提供，写好的物理类型

- 有了标准库之后，PDSL应该添加Import的逻辑

- Interactive mode - 行级的交互界面、GUI

- 原子化操作-若某句话执行错误，回滚到上一句，数据库的思想，将PDSL视作事务

## 四、分工 

### 庄博尔

词法分析的设计和实现(保留字，字符串和标识符的优先级修正)

后端部分python代码的编写(Unit Manager，计量单位DAG图和运算规则的逻辑实现)

报告书写

### 靳立晨

语法分析的设计和实现(语法树，语义规则，消除冲突)

用Ocamllex和Ocamlyacc将词法、语法、翻译规则落实到Ocaml语句

报告书写

## 五、对其他组的评价

### Lisp Torch

用python实现了支持torch库调用的Lisp解释器，pre条理很清晰；但语法就是Lisp自身，不知道通过直接书写调库的Lisp函数能否达成相同效果？

### MiniC 的编译与反编译

基本上实现了MiniC的编译与反编译和一些扩展的语法，工作相当Solid。

### 解释性C语言的实现

基本上支持各种C语法的解释执行，Solid Work；对问题的一些讨论和递进解决也挺有趣。

### Chips代码阅读及分析

把体系的内容和编译交互是有创意的想法，但brainfuck语言可能稍微简单了一点。

### 类C的命令式语言 Cm

熟练使用Ocaml完成数千行的类C语法开发，技术能力很坚实。

### LaJVM

论证并优化JVM更好地利用局部性，有相当的技术深度，pre的内容挺有趣。

### 全局范围分析

对函数取值范围做数据流分析是很创新的；也许需要更多实验(比relu更复杂些的函数等)

## 六、参考文献

Ocaml文档, [http://caml.inria.fr](http://caml.inria.fr/)

Frink主页, <https://frinklang.org/>

python词法, https://docs.python.org/3/reference/lexical_analysis.html#other-tokens