%token 
%%

sentence_list
	: /*empty*/
	: sentence sentence_list 
	;

sentence /*每个sentence就是一个基本处理单元*/
	: class_def 
	| func_def 
	| single_sentence 
	;

class_def /*TODO：可选语句的支持，顺序不一定要是确定的*/
	: CLASS IDENT LCP 
		NAME ASSIGN IDENT 
		/*optional: RELATION ASSIGN relation_exp*/
		/*optional: TYPE VECTOR/SCALAR (default: scalar)*/
		single_assign_list 
	RCP
	;

relation_exp
	: relation MULTI relation_exp  
	| relation DIV relation_exp
	| LP relation RP 
	| IDENT
	;

single_assign_list /*公制单位换算，这样写不会出现递归问题*/
	: /*empty*/
	: single_assign_list single_assign
	;

single_assign
	: NUM IDENT ASSIGN NUM IDENT 
	;


func_def
	: DEF IDENT LP paralist RP code_block
	;

paralist
	: /*empty*/
	| paralist COMMA para
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

branch
	: if LP exp RP code_block ELSE code_block 
	| if LP exp RP code_block
	;

recurr 
	: FOR IDENT in interval
	LCP sentence_list RCP
	;
interval
	: ( exp , exp) |
	  (exp , exp, exp)
	 ;

// = 从右往左
// 其余算符从左往右
exp: t1 assign exp | t1

t1: t2 EQ t1 | t2 NEQ t1 | t2

t2: t3 AND t2 | t3 OR t2 | t3

t3: t4 GT t3 | t4 LE t3 | t4 GEQ t3 | t4 LEQ t3 | t4

t4: t5 PLUS t4 | t5 MINUS t4 | t5

t5: t6 MOD t5 | t6 MULTI t5 | t6 DIV t5 | t6

t6: t7 CROSS t6 | t7

t7: MINUS t8 | NOT t8 | t8 //直接取负号

t8: LP exp RP | UNINT | INT | FLOAT | STRING | IDENT | IDENT ( P_List ) | IDENT_list

P_List:
	EMPTY | exp | exp , P_List

IDENT_list:
	IDENT | IDENT(P_List) | IDENT DOT IDENT_list 
	| IDENT(P_List) DOT IDNET_list
%%
