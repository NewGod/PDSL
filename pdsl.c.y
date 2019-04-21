%token 
%%

sentence_list
	: %empty
	| sentence sentence_list
	;

sentence /*每个sentence就是一个基本处理单元*/
	: class_def 
	| func_def 
	| single_sentence 
	;

class_def /*TODO：可选语句的支持，顺序不一定要是确定的*/
	: CLASS IDENT LCP 
		NAME ASSIGN STRING
		/*optional: RELATION ASSIGN relation_exp*/
		/*optional: TYPE VECTOR/SCALAR (default: scalar)*/
		single_assign_list 
	RCP
	;

relation_exp
	: relation MULTI relation_exp  
	| relation DIV relation_exp
	| LP relation RP 
	| STRING POW NUM
	;

single_assign_list /*公制单位换算，这样写不会出现递归问题*/
	: %empty
	| single_assign_list single_assign
	;

single_assign
	: NUM STRING ASSIGN NUM relation_exp
	;


func_def
	: DEF IDENT LP para_list RP code_block
	;

para_list
	:%empty
	| non_empty_para_list
	;
	
non_empty_para_list
	: non_empty_para_list COMMA para
	| para
	;

para
	: IDENT COLON IDENT
	| IDENT
	;

single_sentence
	: code_block
	| branch 
	| recurr 
	| exp
	;

code_block
	: LCP 
		sentence_list 
	RCP
	;

branch
	: IF LP exp RP 
		code_block 
	ELSE 
		code_block 
	| IF LP exp RP code_block
	;

recurr 
	: FOR IDENT IN interval
		code_block
	;
interval
	: LP exp COMMA exp RP 
	| LP exp COMMA exp COMMA exp RP
	;

// = 从右往左
// 其余算符从左往右
exp
	: t1 ASSIGN exp 
	| t1
	;

t1
	: t2 EQ t1 
	| t2 NEQ t1 
	| t2
	;

t2
	: t3 AND t2 
	| t3 OR t2 
	| t3
	;

t3
	: t4 GT t3 
	| t4 LE t3 
	| t4 GEQ t3 
	| t4 LEQ t3 
	| t4
	;

t4
	: t5 PLUS t4 
	| t5 MINUS t4 
	| t5
	;

t5
	: t6 MOD t5 
	| t6 MULTI t5 
	| t6 DIV t5 
	| t6
	;

t6
	: t7 CROSS t6 
	| t7
	;

t7
	: MINUS t8 
	| NOT t8 
	| t8 //直接取负号
	| t8 dot_list
	;
	
dot_list
	: DOT ident dot_list //第一个点后面就没有常数或者括号的表示了,按一个旁支处理
	| DOT ident
	;
	
ident
	: IDENT
	| ident LP p_list RP //对于函数调用如此处理，允许函数对象的出现
	;

t8 
	: LP exp RP 
	| var /*TODO: 还差一个. 和 函数a(p_list)*/
	| t8 LP p_list RP //函数调用和var地位一致
	;

var
	: basic_exp //constant with or without unit
	| IDENT
	;
	
basic_exp
	: num_exp
	| num_exp relation_exp
	;
	
num_exp
	: NUM
	| LP num_list RP
	| LMP num_list LMP
	;
	
num_list
	: NUM
	| NUM COMMA num_list
	;

p_list
	: %empty
	| non_empty_p_list
	;
	
non_empty_p_list 
	: exp 
	| exp COMMA non_empty_p_list
	;
%%
