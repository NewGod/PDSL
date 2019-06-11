%{
let indent_cnt = ref 0;;
let curr_idtstr = ref "";;
let func_cnt = ref 0;;
let curr_name = ref "";;
module Stringmap = Map.Make(String);;
let var_table = ref Stringmap.empty;;
let class_table = ref Stringmap.empty;;
let tmp = ref "";;
let add k x y = 
  	match x,y with
  	None,None -> Some 0.0
  	| Some f, None -> Some f
  	| None, Some f -> Some f
  	| Some f1, Some f2 -> Some (f1 +. f2);;
let sub1 k x y = 
  	match x,y with
  	None,None -> Some 0.0
  	| Some f, None -> Some f
  	| None, Some f -> Some (-.f)
  	| Some f1, Some f2 -> Some (f1 -. f2);;
let addstring k v =
		tmp := (tmp.contents ^ "'" ^ k ^ "':" ^ (string_of_float v) ^ ",");;
let mult a = 
	let g x = a *. x in
	g

open String
%}

		%token<string> NUM IDENT STRING
        %token CLASS DEF RETURN IF ELSE IN RELATION TYPE COMMENT
        %token FOR FALSE TRUE LOG_AND LOG_OR LOG_NOT
        %token NAME VECTOR SCALAR CROSS
        %token DOT COLON COMMA NOT OR AND POWER XOR
        %token PLUS MINUS MULTI DIV MOD
        %token LP RP LMP RMP LCP RCP BOUNDARY
        %token ASSIGN EQ GEQ LEQ GT LE NEQ
        %right ASSIGN
        %left PLUS MINUS        /* lowest precedence */
        %left MULTI DIV         /* medium precedence */
        %start main             /* the entry point */
        %type <int> main
%%

main:
	sentence_list 
	{print_endline("main");0}
	;

sentence_list: 
	 epsilon {$1}
	| sentence sentence_list {print_endline("sentence_list")}
	;

epsilon:
	{print_endline("epsilon")}
	;

sentence 
	: class_def {print_endline("class_def")}
	| func_def {}
	| single_sentence {}
	;

class_def 
	: 
	basic_class_def
		/*optional: RELATION ASSIGN relation_exp*/
		maybe_name
		maybe_relation 
		/*optional: TYPE VECTOR/SCALAR (default: scalar)*/
		single_assign_list
	RCP {}
	;

basic_class_def:
	CLASS IDENT LCP
	{
		class_table := (Stringmap.add $2 func_cnt class_table.contents);
		curr_name := $2
	};

maybe_name:
	epsilon
	{
		print_endline (curr_idtstr.contents ^ "Phymanager.add_var('" ^ curr_name.contents ^ "',None)")
	}
	| NAME ASSIGN IDENT BOUNDARY
	{
		print_endline (curr_idtstr.contents ^ "Phymanager.add_var('" ^ curr_name.contents ^ "','" ^ $3 ^ "')")
	};

maybe_relation:
	epsilon {$1}
	| RELATION ASSIGN relation_exp BOUNDARY
	{
		tmp := "{";
		Stringmap.iter addstring $3;
		tmp := tmp.contents ^ "}";
		(*what is the API?*)
		print_endline (curr_idtstr.contents ^ "Phymanager.add_relation('" ^ curr_name.contents ^ "'," ^ tmp.contents ^ ")")
		(*I suppose that's not correct*)
	}
	;

relation_exp
	: relation_exp MULTI relation
	{
		Stringmap.merge add $1 $3
	}
	| relation_exp DIV relation
	{
		Stringmap.merge sub1 $1 $3
	}
	| relation
	{
		$1
	}
	;

relation:
	| LP relation_exp RP 
	{
		$2
	}
	| relation POWER single_const_exp
	{
		Stringmap.map (mult $3) $1
	}
	| IDENT
	{
		Stringmap.add $1 1.0 Stringmap.empty
	}
	;

single_const_exp:
	ct1 PLUS single_const_exp
	{$1 +. $3}
	| ct2 MINUS single_const_exp
	{$1 -. $3}
	| ct1 {$1}

ct1:
	ct2 MULTI ct1
	{$1 *. $3}
	| ct2 DIV ct1
	{$1 /. $3}
	| ct2 {$1}
ct2:
	LP single_const_exp RP
	{$2}
	| MINUS ct2
	{-.$2}
	| NUM
	{float_of_string $1}

single_assign_list 
	: epsilon {$1}
	| single_assign_list single_assign BOUNDARY
	{
		print_endline (curr_idtstr.contents ^ $2)
	}
	;

single_assign
	: NUM IDENT ASSIGN NUM IDENT
	{
		"Phymanager.add_subunit('" ^ $2 ^ "','" ^ $5 ^ "'," ^ string_of_float((float_of_string $4) /. (float_of_string $1)) ^ ")"
	}
	;


func_def
	: 
	basic_func_def
	code_block{}
	;

basic_func_def:
	DEF IDENT LP para_list RP 
	{
		print_endline (curr_idtstr.contents ^ "def " ^ $2 ^ "(" ^ $4 ^ ")")
	}

para_list
	:
	epsilon
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
	: code_block {}
	| branch {}
	| recurr {}
	| exp BOUNDARY
	{
		print_endline (curr_idtstr.contents ^ $1)
	}
	;

code_block
	: 
	lcp_addident 
	sentence_list 
	rcp_subident
	{}
	;

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

branch
	: 
	basic_branch_if 
	code_block 
	basic_else
	code_block {}
	| basic_branch_if
	code_block {}
	;

basic_branch_if:
	IF LP t1 RP
	{
			print_endline (curr_idtstr.contents ^ "if " ^ $3 ^ ":")
	};
basic_else:
	ELSE
	{
		print_endline (curr_idtstr.contents ^ "else:")
	};

recurr 
	: basic_recurr
		code_block {}
	;

basic_recurr:
	FOR IDENT IN interval
		{
			print_endline (curr_idtstr.contents ^ "for " ^ $2 ^ " in " ^ $4 ^ ":")
		};

interval
	: 
	LP t1 RP
	{
		"range(" ^ $2 ^ ")"
	}
	| LP t1 COMMA t1 RP 
	{
		"range(" ^ $2 ^ "," ^ $4 ^ ")"
	}
	| LP t1 COMMA t1 COMMA t1 RP
	{
		"range(" ^ $2 ^ "," ^ $4 ^ "," ^ $6 ^ ")"
	}
	;

exp
	: IDENT ASSIGN exp 
	{
		var_table := Stringmap.add $1 func_cnt.contents var_table.contents;
		$1 ^ " = " ^ $3
	}
	| t1
	{
		$1
	}
	;

t1
	: t2 LOG_AND t1 
	{
		$1 ^ " and " ^ $3
	}
	| t2 LOG_OR t1 
	{
		$1 ^ " or " ^ $3
	}
	| t2
	{
		$1
	}
	;

t2
	: t3 EQ t2 
	{
		$1 ^ "==" ^ $3
	}
	| t3 NEQ t2 
	{
		$1 ^ "!=" ^ $3
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
		$1 ^ ".cross(" ^ $3 ^ ")"
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
	| LOG_NOT t8 
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
	: LP t1 RP 
	{
		"(" ^ $2 ^ ")"
	}
	| t1 LMP relation_exp RMP
	{
		tmp := "{";
		Stringmap.iter addstring $3;
		tmp := tmp.contents ^ "}";
		(*what is the API?*)
		(*I suppose that's not correct*)
		"PhyVar(" ^ $1 ^ "," ^ tmp.contents ^ ",True)"
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
	| STRING
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
	: epsilon
	{
		""
	}
	| non_empty_p_list
	{
		$1
	}
	;
	
non_empty_p_list 
	: t1 
	{
		$1
	}
	| t1 COMMA non_empty_p_list
	{
		$1 ^ "," ^ $3
	}
	;
%%
