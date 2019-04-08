ident = [a-zA-Z\_][a-zA-Z0-9\_]*

digit = [0-9]
unint = digit+
int = digit+
frac = \.digit+
exp = [eE][\-\+]?digit+
float digit*frac+ exp?

newline = \r|\n|
string = ([\'\"]) [^newline]* (1)
whitespace ([\ \t])+
%%

 /*Warning: 
 * 没有考虑任何的优先级，不对正则的正确性做任何保证
 */
whitespace {return WHITESPACE} 
"class" {return CLASS} /*类定义*/
"def" {return DEF} /*函数定义*/
"return" {return RETURN} /*返回值*/
"if" {return IF} 
"for" {return FOR} 
":" {return COLON}
"." {return DOT} /*类成员*/
"," {return COMMA}

 /*字符串类型：
 * 单字符要不要支持
 * 单引号和双引号和三引号要不要支持(python format string)
 */ 
string {return STRING}

 /*数字类型（可能要写在一起）*/
unint {return NUM_UNINT;}
int {return NUM_INT;}
float {return NUM_FLOAT} 

 /*赋值运算符*/
"=" {return ASSIGN}

"false" {return FALSE}
"true" {return TRUE} 

 /*比较运算符（可能要写在一起）*/
"==" {return EQ} 
"!=" {return NEQ} 
">=" {return GEQ} 
"<=" {return LEQ} 
">" {return GT} 
"<" {return LE} 
"!" {return NOT} 
"**" {return POWER}
"^" {return OR}
"&" {return AND} 
"and" {return LOG_AND}
"or" {return LOG_OR} 
"not" {return LOG_NOT}

 /*加减乘除运算符（可能要写在一起）*/
"+" {return PLUS} 
"-" {return MINUS} 
"*" {return MULTI} 
"/" {return DIV}
"%" {return MOD}
"cross" {return CROSS}

 /*Python format commet 
 * 块注释考虑一下？	
 */ 
"#" {return COMMENT} 

 /*左右括号*/
"(" {return LBRACKETS} 
"(" {return RBRACKETS} 
"{" {return LCURBRACKETS} /*考虑用c的代码块表示方式？用python的好实现么？*/
"}" {return RCURBRACKETS}
"[" {return LSQUBRACKETS} 
"]" {return RSQUBARCKETS} 

"relation" {return RELATION}
"type" {return TYPE}
"name" {return NAME}
"vector" {return VECTOR} 
"scalar" {return SCALAR}
ident {return IDENT}

%%