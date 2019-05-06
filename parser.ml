type token =
  | NUM of (float)
  | CLASS
  | DEF
  | RETURN
  | IF
  | IN
  | RELATION
  | TYPE
  | FOR
  | FALSE
  | TRUE
  | LOG_AND
  | LOG_OR
  | LOG_NOT
  | NAME
  | VECTOR
  | SCALOR
  | CROSS
  | STRING
  | IDENT
  | DOT
  | COLON
  | COMMA
  | NOT
  | OR
  | AND
  | POWER
  | XOR
  | PLUS
  | MINUS
  | MULTI
  | DIV
  | MOD
  | LP
  | RP
  | LMP
  | RMP
  | LCP
  | RCP
  | ASSIGN
  | EQ
  | GEQ
  | LEQ
  | GT
  | LE
  | NEQ

open Parsing;;
let _ = parse_error;;
let yytransl_const = [|
  258 (* CLASS *);
  259 (* DEF *);
  260 (* RETURN *);
  261 (* IF *);
  262 (* IN *);
  263 (* RELATION *);
  264 (* TYPE *);
  265 (* FOR *);
  266 (* FALSE *);
  267 (* TRUE *);
  268 (* LOG_AND *);
  269 (* LOG_OR *);
  270 (* LOG_NOT *);
  271 (* NAME *);
  272 (* VECTOR *);
  273 (* SCALOR *);
  274 (* CROSS *);
  275 (* STRING *);
  276 (* IDENT *);
  277 (* DOT *);
  278 (* COLON *);
  279 (* COMMA *);
  280 (* NOT *);
  281 (* OR *);
  282 (* AND *);
  283 (* POWER *);
  284 (* XOR *);
  285 (* PLUS *);
  286 (* MINUS *);
  287 (* MULTI *);
  288 (* DIV *);
  289 (* MOD *);
  290 (* LP *);
  291 (* RP *);
  292 (* LMP *);
  293 (* RMP *);
  294 (* LCP *);
  295 (* RCP *);
  296 (* ASSIGN *);
  297 (* EQ *);
  298 (* GEQ *);
  299 (* LEQ *);
  300 (* GT *);
  301 (* LE *);
  302 (* NEQ *);
    0|]

let yytransl_block = [|
  257 (* NUM *);
    0|]

let yylhs = "\255\255\
\001\000\000\000"

let yylen = "\002\000\
\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\001\000\002\000"

let yydgoto = "\002\000\
\004\000"

let yysindex = "\255\255\
\000\255\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000"

let yytablesize = 1
let yytable = "\001\000\
\003\000"

let yycheck = "\001\000\
\001\001"

let yynames_const = "\
  CLASS\000\
  DEF\000\
  RETURN\000\
  IF\000\
  IN\000\
  RELATION\000\
  TYPE\000\
  FOR\000\
  FALSE\000\
  TRUE\000\
  LOG_AND\000\
  LOG_OR\000\
  LOG_NOT\000\
  NAME\000\
  VECTOR\000\
  SCALOR\000\
  CROSS\000\
  STRING\000\
  IDENT\000\
  DOT\000\
  COLON\000\
  COMMA\000\
  NOT\000\
  OR\000\
  AND\000\
  POWER\000\
  XOR\000\
  PLUS\000\
  MINUS\000\
  MULTI\000\
  DIV\000\
  MOD\000\
  LP\000\
  RP\000\
  LMP\000\
  RMP\000\
  LCP\000\
  RCP\000\
  ASSIGN\000\
  EQ\000\
  GEQ\000\
  LEQ\000\
  GT\000\
  LE\000\
  NEQ\000\
  "

let yynames_block = "\
  NUM\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : float) in
    Obj.repr(
# 16 "parser.mly"
        ()
# 191 "parser.ml"
               : int))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : int)
