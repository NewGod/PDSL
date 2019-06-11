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
        FOR FALSE TRUE LOG_AND LOG_OR LOG_NOT
        NAME VECTOR SCALAR CROSS
        DOT COLON COMMA NOT OR AND POWER XOR
        PLUS MINUS MULTI DIV MOD
        LP RP LMP RMP LCP RCP BOUNDARY
        ASSIGN EQ GEQ LEQ GT LE NEQ
        %right ASSIGN
        %left LOG_AND
        %left LOG_OR
        %nonassoc NEQ EQ
        %nonassoc LEQ GEQ LE GT       /* lowest precedence */
        %left PLUS MINUS        /* lowest precedence */
        %left MOD MULTI DIV         /* medium precedence */
        %left CROSS
        %nonassoc UMINUS ULOG_NOT
        %start main             /* the entry point */
        %type <int> main
%%

main:
	sentence_list 
	{0}
	;

sentence_list: 
	 {}
	| sentence_list sentence {}
	;


sentence 
	: class_def {}
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
	{
		print_endline (curr_idtstr.contents ^ "Phymanager.add_var('" ^ curr_name.contents ^ "',None)")
	}
	| NAME ASSIGN IDENT BOUNDARY
	{
		print_endline (curr_idtstr.contents ^ "Phymanager.add_var('" ^ curr_name.contents ^ "','" ^ $3 ^ "')")
	};

maybe_relation:
	{}
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
	: {}
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
	code_block
	{}
	;

basic_func_def:
	DEF IDENT LP para_list RP 
	{
		print_endline (curr_idtstr.contents ^ "def " ^ $2 ^ "(" ^ $4 ^ ")")
	}

para_list
	:
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
	: IDENT
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

code_block_return:
	lcp_addident 
	sentence_list 
	RETURN BOUNDARY
	rcp_subident
	{}

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
	: t1 LOG_AND t1
	{
		$1 ^ " and " ^ $3
	}
	| t1 LOG_OR t1
	{
		$1 ^ " or " ^ $3
	}
	| t1 EQ t1 
	{
		$1 ^ "==" ^ $3
	}
	| t1 NEQ t1 
	{
		$1 ^ "!=" ^ $3
	}
	| t1 GT t1 
	{
		$1 ^ ">" ^ $3
	}
	| t1 LE t1 
	{
		$1 ^ "<" ^ $3
	}
	| t1 GEQ t1 
	{
		$1 ^ ">=" ^ $3
	}
	| t1 LEQ t1
	{
		$1 ^ "<=" ^ $3
	} 
	| t1 PLUS t1 
	{
		$1 ^ "+" ^ $3
	}
	| t1 MINUS t1 
	{
		$1 ^ "-" ^ $3
	}
	| t1 MOD t1
	{
		$1 ^ "%" ^ $3
	}
	| t1 MULTI t1 
	{
		$1 ^ "*" ^ $3
	}
	| t1 DIV t1 
	{
		$1 ^ "/" ^ $3
	}
	| t1 CROSS t1 
	{
		$1 ^ ".cross(" ^ $3 ^ ")"
	}
	| MINUS t1 %prec UMINUS
	{
		"-" ^ $2
	}
	| LOG_NOT t1 %prec ULOG_NOT
	{
		"not " ^ $2
	}
    | t2 
    {
        $1
    }
    ;
t2
	: t8
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
	| num_list COMMA NUM
	{
		$1 ^ "," ^ $3
	}
	;

p_list
	: 
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
	| non_empty_p_list COMMA t1
	{
		$1 ^ "," ^ $3
	}
	;
%%
