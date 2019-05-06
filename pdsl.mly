%{
let indent_cnt = 0;;
let curr_idtstr = "";;
let val_table = {};;
let class_table = {};;
open String
%}

%token <string> NUM IDENT
        %token CLASS DEF RETURN IF IN RELATION TYPE
        %token FOR FALSE TRUE LOG_AND LOG_OR LOG_NOT
        %token NAME VECTOR SCALOR CROSS STRING
        %token DOT COLON COMMA NOT OR AND POWER XOR
        %token PLUS MINUS MULTI DIV MOD
        %token LP RP LMP RMP LCP RCP BOUNDARY
        %token ASSIGN EQ GEQ LEQ GT LE NEQ
        %left PLUS MINUS        /* lowest precedence */
        %left MULTI DIV         /* medium precedence */
        %right ASSIGN
        %start main             /* the entry point */
        %type <int> main
%%

main:
	sentence_list
	;

sentence_list
	: %empty
	| sentence sentence_list
	;

sentence 
	: class_def 
	| func_def 
	| single_sentence
	;

class_def 
	: CLASS IDENT LCP 
	{
		let indent_cnt = indent_cnt + 1;;
	}
		NAME ASSIGN IDENT BOUNDARY
		{
			printf_endline "Phymanager.addclass(" ^ $2 ^ "," ^ $6 ^ ")"
		}
		/*optional: RELATION ASSIGN relation_exp*/
		/*optional: TYPE VECTOR/SCALAR (default: scalar)*/
		single_assign_list 
	RCP
	{
		let indent_cnt = indent_cnt - 1;;
		if indent_cnt < 0 
		then printf_endline "bad indent"
		else 
		let curr_idtstr = String.sub curr_idtstr, 1, indent_cnt;;
	}
	;

relation_exp
	: relation MULTI relation_exp  
	{
		$1 ^ "*" ^ $3
	}
	| relation DIV relation_exp
	{
		$1 ^ "/" ^ $3
	}
	| relation
	{
		$1
	}
	;

relation:
	| LP relation_exp RP 
	{
		"(" ^ $2 ^ ")"
	}
	| IDENT POWER NUM
	{
		$1 ^ "**" ^ $3
	}
	| IDENT
	{
		$1
	}
	;

single_assign_list 
	: %empty
	| single_assign_list single_assign BOUNDARY
	{
		printf_endline curr_idtstr ^ $2
	}
	;

single_assign
	: NUM IDENT ASSIGN NUM IDNET
	{
		"Phymanager.addrelation(" ^ $2 ^ "," ^ $5 ^ "," ^ string($4 / $1) ^ ")"
	}
	;


func_def
	: DEF IDENT LP para_list RP 
	{
		printf_endline curr_idtstr ^ "def" ^ $2 ^ "(" ^ $4 ^ "):"
	}
	code_block
	;

para_list
	:%empty
	{
		""
	}
	| non_empty_para_list
	{
		$1
	}
	;
	
non_empty_para_list
	: non_empty_para_list COMMA para
	{
		$1 ^ "," ^ $3
	}
	| para
	{
		$1
	}
	;

para
	: IDENT COLON IDENT
	{
		$1 ^ ":" ^ $3
	}
	| IDENT
	{
		$1
	}
	;

single_sentence
	: code_block
	| branch 
	| recurr 
	| exp BOUNDARY
	{
		printf_endline curr_idtstr ^ $1;
	}
	;

code_block
	: LCP 
	{
		let indent_cnt = indent_cnt + 1;
		let curr_idtstr = curr_idtstr ^ "\t";
	}
		sentence_list 
	RCP
	{
		let indent_cnt = indent_cnt - 1;
		if indent_cnt < 0 
		then printf "bad indent"
		else 
		let curr_idtstr = String.sub curr_idtstr, 1, indent_cnt
	}
	;

branch
	: IF LP exp RP 
		{
			printf_endline curr_idtstr ^ "if" ^ $3 ^ ":"
		}
		code_block 
	ELSE 
	{
		printf_endline curr_idtstr ^ "else:"
	}
		code_block 
	| IF LP exp RP 
		{
			printf_endline curr_idtstr ^ "if" ^ $3 ^ ":"
		}
	code_block
	;

recurr 
	: FOR IDENT IN interval
		{
			printf_endline curr_idtstr ^ "for" ^ $2 ^ "in" $4 ^ ":"
		}
		code_block
	;
interval
	: LP exp COMMA exp RP 
	{
		"range(" ^ $2 ^ "," ^ $4 ^ ")"
	}
	| LP exp COMMA exp COMMA exp RP
	{
		"range(" ^ $2 ^ "," ^ $4 ^ "," ^ $6 ^ ")"
	}
	;

exp
	: IDENT ASSIGN exp 
	{
		$1 ^ " = " ^ $3
	}
	| t1
	{
		$1
	}
	;

t1
	: t2 EQ t1 
	{
		$1 ^ "==" ^ $3
	}
	| t2 NEQ t1 
	{
		$1 ^ "!=" ^ $3
	}
	| t2
	{
		$1
	}
	;

t2
	: t3 AND t2 
	{
		$1 ^ " and " ^ $3
	}
	| t3 OR t2 
	{
		$1 ^ " or " ^ $3
	}
	| t3
	{
		$1
	}
	;

t3
	: t4 GT t3 
	{
		$1 ^ ">" ^ $3
	}
	| t4 LE t3 
	{
		$1 ^ "<" ^ $3
	}
	| t4 GEQ t3 
	{
		$1 ^ ">=" ^ $3
	}
	| t4 LEQ t3
	{
		$1 ^ "<=" ^ $3
	} 
	| t4
	{
		$1
	}
	;

t4
	: t5 PLUS t4 
	{
		$1 ^ "+" ^ $3
	}
	| t5 MINUS t4 
	{
		$1 ^ "-" ^ $3
	}
	| t5
	{
		$1
	}
	;

t5
	: t6 MOD t5 
	{
		$1 ^ "%" ^ $3
	}
	| t6 MULTI t5 
	{
		$1 ^ "*" ^ $3
	}
	| t6 DIV t5 
	{
		$1 ^ "/" ^ $3
	}
	| t6
	{
		$1
	}
	;

t6
	: t7 CROSS t6 
	{
		"cross(" ^ $1 ^ "," ^ $3 ^ ")"
	}
	| t7
	{
		$1
	}
	;

t7
	: MINUS t8 
	{
		"-" ^ $2
	}
	| NOT t8 
	{
		"not " ^ $2
	}
	| t8
	{
		$1
	}
	| t8 dot_list
	{
		$1 ^ $2
	}
	;
	
dot_list
	: DOT ident dot_list
	{
		"." ^ $2 ^ $3
	}
	| DOT ident
	{
		"." ^ $2
	}
	;
	
ident
	: IDENT
	{
		$1
	}
	| ident LP p_list RP
	{
		$1 ^ "(" ^ $3 ^ ")"
	}
	;

t8 
	: LP exp RP 
	{
		"(" ^ $2 ^ ")"
	}
	| exp relation_exp
	{
		"PhyVar(" ^ $1 ^ "," ^ $2 ^ ")"
	}
	| var
	{
		$1
	}
	| t8 LP p_list RP
	{
		$1 ^ "(" ^ $3 ^ ")"
 	}
	;

var
	: num_exp
	{
		$1
	}
	| IDENT
	{
		$1
	}
	;
	
num_exp
	: NUM
	{
		$1
	}
	| LMP num_list LMP
	{
		"(" ^ $2 ^ ")"
	}
	;
	
num_list
	: NUM
	{
		$1
	}
	| NUM COMMA num_list
	{
		$1 ^ "," ^ $3
	}
	;

p_list
	: %empty
	{
		""
	}
	| non_empty_p_list
	{
		$1
	}
	;
	
non_empty_p_list 
	: exp 
	{
		$1
	}
	| exp COMMA non_empty_p_list
	{
		$1 ^ "," ^ $3
	}
	;
%%
