type token =
  | NUM of (string)
  | IDENT of (string)
  | STRING of (string)
  | CLASS
  | DEF
  | RETURN
  | IF
  | ELSE
  | IN
  | RELATION
  | TYPE
  | COMMENT
  | FOR
  | FALSE
  | TRUE
  | LOG_AND
  | LOG_OR
  | LOG_NOT
  | NAME
  | VECTOR
  | SCALAR
  | CROSS
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
  | BOUNDARY
  | ASSIGN
  | EQ
  | GEQ
  | LEQ
  | GT
  | LE
  | NEQ

open Parsing;;
let _ = parse_error;;
# 2 "ocaml/pdsl_parser.mly"
let indent_cnt = ref 0;;
let curr_idtstr = ref "";;
let func_cnt = ref 0;;
let curr_name = ref "";;
let assgin_value = ref "";;
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
# 84 "ocaml/pdsl_parser.ml"
let yytransl_const = [|
  260 (* CLASS *);
  261 (* DEF *);
  262 (* RETURN *);
  263 (* IF *);
  264 (* ELSE *);
  265 (* IN *);
  266 (* RELATION *);
  267 (* TYPE *);
  268 (* COMMENT *);
  269 (* FOR *);
  270 (* FALSE *);
  271 (* TRUE *);
  272 (* LOG_AND *);
  273 (* LOG_OR *);
  274 (* LOG_NOT *);
  275 (* NAME *);
  276 (* VECTOR *);
  277 (* SCALAR *);
  278 (* CROSS *);
  279 (* DOT *);
  280 (* COLON *);
  281 (* COMMA *);
  282 (* NOT *);
  283 (* OR *);
  284 (* AND *);
  285 (* POWER *);
  286 (* XOR *);
  287 (* PLUS *);
  288 (* MINUS *);
  289 (* MULTI *);
  290 (* DIV *);
  291 (* MOD *);
  292 (* LP *);
  293 (* RP *);
  294 (* LMP *);
  295 (* RMP *);
  296 (* LCP *);
  297 (* RCP *);
  298 (* BOUNDARY *);
  299 (* ASSIGN *);
  300 (* EQ *);
  301 (* GEQ *);
  302 (* LEQ *);
  303 (* GT *);
  304 (* LE *);
  305 (* NEQ *);
    0|]

let yytransl_block = [|
  257 (* NUM *);
  258 (* IDENT *);
  259 (* STRING *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\003\000\003\000\003\000\004\000\007\000\
\008\000\008\000\009\000\009\000\011\000\011\000\011\000\012\000\
\012\000\012\000\014\000\014\000\014\000\015\000\015\000\015\000\
\013\000\013\000\013\000\010\000\010\000\016\000\005\000\017\000\
\019\000\019\000\020\000\020\000\021\000\006\000\006\000\006\000\
\006\000\022\000\018\000\026\000\027\000\023\000\023\000\028\000\
\029\000\024\000\031\000\032\000\032\000\032\000\025\000\025\000\
\030\000\030\000\030\000\030\000\030\000\030\000\030\000\030\000\
\030\000\030\000\033\000\033\000\034\000\034\000\034\000\034\000\
\034\000\034\000\034\000\034\000\035\000\035\000\035\000\035\000\
\037\000\037\000\037\000\038\000\038\000\039\000\039\000\036\000\
\036\000\040\000\040\000\000\000"

let yylen = "\002\000\
\001\000\000\000\002\000\001\000\001\000\001\000\005\000\003\000\
\000\000\004\000\000\000\004\000\003\000\003\000\001\000\003\000\
\003\000\001\000\003\000\003\000\001\000\003\000\003\000\001\000\
\003\000\002\000\001\000\000\000\003\000\005\000\002\000\005\000\
\000\000\001\000\003\000\001\000\001\000\001\000\001\000\001\000\
\002\000\003\000\005\000\001\000\001\000\004\000\002\000\004\000\
\001\000\002\000\004\000\003\000\005\000\007\000\003\000\001\000\
\003\000\003\000\002\000\003\000\003\000\003\000\003\000\003\000\
\003\000\001\000\004\000\001\000\003\000\003\000\003\000\003\000\
\003\000\003\000\002\000\001\000\003\000\004\000\003\000\001\000\
\001\000\001\000\001\000\001\000\003\000\001\000\003\000\000\000\
\001\000\001\000\003\000\002\000"

let yydefred = "\000\000\
\002\000\000\000\092\000\000\000\084\000\000\000\082\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\044\000\
\003\000\004\000\005\000\006\000\000\000\000\000\038\000\039\000\
\040\000\000\000\002\000\000\000\000\000\000\000\000\000\000\000\
\000\000\080\000\081\000\000\000\000\000\000\000\000\000\000\000\
\083\000\000\000\075\000\000\000\086\000\000\000\000\000\000\000\
\031\000\002\000\041\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\050\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\055\000\
\008\000\000\000\000\000\000\000\079\000\000\000\085\000\000\000\
\000\000\028\000\000\000\045\000\042\000\049\000\000\000\000\000\
\000\000\000\000\064\000\065\000\062\000\063\000\000\000\018\000\
\000\000\000\000\000\000\074\000\000\000\000\000\000\000\000\000\
\000\000\077\000\000\000\000\000\000\000\037\000\000\000\000\000\
\036\000\048\000\000\000\051\000\087\000\000\000\000\000\000\000\
\000\000\046\000\000\000\000\000\000\000\067\000\000\000\078\000\
\000\000\032\000\000\000\000\000\010\000\000\000\000\000\007\000\
\000\000\000\000\016\000\000\000\000\000\027\000\000\000\000\000\
\017\000\000\000\035\000\000\000\052\000\012\000\000\000\029\000\
\043\000\026\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\025\000\000\000\000\000\053\000\000\000\020\000\
\000\000\022\000\023\000\019\000\000\000\030\000\054\000"

let yydgoto = "\002\000\
\003\000\004\000\017\000\018\000\019\000\020\000\021\000\048\000\
\082\000\120\000\098\000\099\000\155\000\156\000\157\000\137\000\
\022\000\049\000\111\000\112\000\113\000\023\000\024\000\025\000\
\026\000\027\000\085\000\028\000\087\000\029\000\030\000\116\000\
\031\000\032\000\033\000\108\000\034\000\035\000\046\000\109\000"

let yysindex = "\016\000\
\000\000\000\000\000\000\130\255\000\000\254\254\000\000\032\255\
\055\255\024\255\095\255\020\255\082\255\020\255\121\255\000\000\
\000\000\000\000\000\000\000\000\105\255\086\255\000\000\000\000\
\000\000\088\255\000\000\086\255\135\255\086\255\090\255\125\255\
\038\255\000\000\000\000\137\255\106\255\113\255\020\255\145\255\
\000\000\089\000\000\000\207\000\000\000\063\255\118\255\157\255\
\000\000\000\000\000\000\068\255\166\255\020\255\020\255\020\255\
\020\255\020\255\020\255\020\255\020\255\000\000\004\255\082\255\
\082\255\082\255\082\255\082\255\082\255\163\255\020\255\000\000\
\000\000\183\255\220\000\140\255\000\000\191\255\000\000\192\255\
\152\255\000\000\089\255\000\000\000\000\000\000\086\255\195\255\
\089\000\205\255\000\000\000\000\000\000\000\000\205\255\000\000\
\004\255\043\255\167\255\000\000\252\254\252\254\185\255\185\255\
\185\255\000\000\135\255\161\255\194\255\000\000\171\255\200\255\
\000\000\000\000\020\255\000\000\000\000\175\255\004\255\010\255\
\186\255\000\000\079\255\004\255\004\255\000\000\003\255\000\000\
\020\255\000\000\183\255\183\000\000\000\108\255\214\255\000\000\
\187\255\206\255\000\000\167\255\167\255\000\000\003\255\003\255\
\000\000\135\255\000\000\020\255\000\000\000\000\212\255\000\000\
\000\000\000\000\046\255\193\255\201\255\201\000\008\000\003\255\
\003\255\003\255\000\000\003\255\020\255\000\000\254\255\000\000\
\111\255\000\000\000\000\000\000\226\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\011\001\000\000\155\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\009\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\226\255\000\000\232\255\167\000\
\189\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\247\254\000\000\000\000\000\000\000\000\000\000\012\255\
\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\235\255\000\000\
\000\000\236\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\073\255\
\229\255\133\000\000\000\000\000\000\000\000\000\004\001\000\000\
\000\000\000\000\176\255\000\000\115\000\149\000\013\000\047\000\
\081\000\000\000\245\254\000\000\245\255\000\000\000\000\246\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\032\000\066\000\000\000\000\000\000\000\
\000\000\062\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\074\255\000\000\247\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\074\255\000\000\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\238\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\174\255\156\255\149\255\215\255\002\000\000\000\
\000\000\000\000\000\000\000\000\156\000\231\255\000\000\000\000\
\252\000\012\001\153\000\000\000\000\000\244\255\000\000\000\000\
\000\000\255\255\000\000\000\000\000\000\000\000\000\000\000\000"

let yytablesize = 558
let yytable = "\042\000\
\047\000\044\000\053\000\142\000\062\000\096\000\059\000\059\000\
\052\000\009\000\135\000\043\000\011\000\090\000\123\000\059\000\
\001\000\064\000\009\000\145\000\005\000\041\000\007\000\140\000\
\141\000\090\000\075\000\059\000\067\000\068\000\069\000\083\000\
\059\000\037\000\143\000\154\000\134\000\012\000\144\000\097\000\
\036\000\088\000\089\000\090\000\091\000\092\000\093\000\094\000\
\095\000\009\000\136\000\013\000\011\000\169\000\169\000\014\000\
\038\000\015\000\107\000\039\000\070\000\122\000\100\000\101\000\
\102\000\103\000\104\000\105\000\005\000\006\000\007\000\008\000\
\009\000\071\000\010\000\124\000\125\000\160\000\161\000\162\000\
\011\000\126\000\005\000\041\000\007\000\012\000\091\000\078\000\
\057\000\005\000\006\000\007\000\008\000\009\000\121\000\010\000\
\040\000\057\000\091\000\013\000\079\000\011\000\132\000\014\000\
\024\000\015\000\012\000\016\000\084\000\057\000\024\000\124\000\
\125\000\013\000\057\000\139\000\146\000\014\000\168\000\015\000\
\013\000\045\000\172\000\047\000\014\000\016\000\015\000\063\000\
\016\000\051\000\005\000\006\000\007\000\008\000\009\000\158\000\
\010\000\005\000\006\000\007\000\124\000\125\000\011\000\161\000\
\162\000\073\000\064\000\012\000\074\000\150\000\054\000\055\000\
\173\000\076\000\012\000\065\000\066\000\067\000\068\000\069\000\
\080\000\013\000\170\000\171\000\106\000\014\000\081\000\015\000\
\013\000\016\000\083\000\083\000\014\000\086\000\015\000\115\000\
\083\000\083\000\056\000\057\000\058\000\059\000\060\000\061\000\
\110\000\083\000\083\000\083\000\083\000\083\000\083\000\117\000\
\083\000\118\000\119\000\127\000\083\000\128\000\083\000\083\000\
\083\000\083\000\083\000\083\000\076\000\076\000\064\000\130\000\
\015\000\015\000\076\000\055\000\015\000\076\000\015\000\151\000\
\133\000\015\000\129\000\076\000\076\000\076\000\076\000\076\000\
\131\000\076\000\076\000\138\000\152\000\163\000\076\000\164\000\
\076\000\076\000\076\000\076\000\076\000\076\000\056\000\057\000\
\058\000\059\000\060\000\061\000\058\000\058\000\084\000\066\000\
\066\000\057\000\058\000\059\000\060\000\058\000\159\000\174\000\
\066\000\047\000\047\000\047\000\047\000\047\000\047\000\047\000\
\167\000\058\000\001\000\056\000\066\000\047\000\058\000\088\000\
\033\000\066\000\047\000\066\000\066\000\066\000\066\000\066\000\
\066\000\089\000\034\000\021\000\072\000\072\000\147\000\072\000\
\047\000\050\000\153\000\000\000\047\000\072\000\047\000\000\000\
\047\000\047\000\000\000\072\000\072\000\072\000\072\000\072\000\
\000\000\072\000\072\000\000\000\000\000\000\000\072\000\000\000\
\072\000\072\000\072\000\072\000\072\000\072\000\073\000\073\000\
\013\000\013\000\000\000\000\000\013\000\000\000\013\000\073\000\
\000\000\013\000\000\000\000\000\000\000\073\000\073\000\073\000\
\073\000\073\000\000\000\073\000\073\000\000\000\000\000\000\000\
\073\000\000\000\073\000\073\000\073\000\073\000\073\000\073\000\
\071\000\071\000\014\000\014\000\000\000\000\000\014\000\000\000\
\014\000\071\000\000\000\014\000\000\000\000\000\000\000\071\000\
\071\000\071\000\071\000\071\000\000\000\071\000\071\000\000\000\
\000\000\000\000\071\000\000\000\071\000\071\000\071\000\071\000\
\071\000\071\000\069\000\069\000\056\000\057\000\058\000\059\000\
\060\000\061\000\000\000\069\000\000\000\000\000\000\000\000\000\
\000\000\069\000\069\000\000\000\060\000\060\000\000\000\069\000\
\069\000\000\000\000\000\000\000\069\000\060\000\069\000\069\000\
\069\000\069\000\069\000\069\000\070\000\070\000\000\000\000\000\
\000\000\060\000\000\000\000\000\000\000\070\000\060\000\000\000\
\000\000\000\000\000\000\070\000\070\000\000\000\068\000\068\000\
\000\000\070\000\070\000\000\000\000\000\000\000\070\000\068\000\
\070\000\070\000\070\000\070\000\070\000\070\000\054\000\055\000\
\000\000\000\000\000\000\068\000\068\000\000\000\000\000\148\000\
\068\000\000\000\068\000\068\000\068\000\068\000\068\000\068\000\
\054\000\055\000\000\000\149\000\000\000\000\000\054\000\055\000\
\000\000\165\000\056\000\057\000\058\000\059\000\060\000\061\000\
\000\000\000\000\000\000\054\000\055\000\166\000\000\000\000\000\
\000\000\054\000\055\000\077\000\056\000\057\000\058\000\059\000\
\060\000\061\000\056\000\057\000\058\000\059\000\060\000\061\000\
\114\000\000\000\000\000\000\000\000\000\000\000\175\000\056\000\
\057\000\058\000\059\000\060\000\061\000\056\000\057\000\058\000\
\059\000\060\000\061\000\061\000\061\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\061\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\061\000\000\000\000\000\000\000\000\000\061\000"

let yycheck = "\012\000\
\000\000\014\000\028\000\001\001\030\000\002\001\016\001\017\001\
\027\000\001\001\001\001\013\000\001\001\025\001\097\000\025\001\
\001\000\022\001\010\001\127\000\001\001\002\001\003\001\124\000\
\125\000\037\001\039\000\037\001\033\001\034\001\035\001\050\000\
\042\001\002\001\032\001\143\000\119\000\018\001\036\001\036\001\
\043\001\054\000\055\000\056\000\057\000\058\000\059\000\060\000\
\061\000\041\001\041\001\032\001\041\001\161\000\162\000\036\001\
\002\001\038\001\071\000\036\001\023\001\087\000\064\000\065\000\
\066\000\067\000\068\000\069\000\001\001\002\001\003\001\004\001\
\005\001\036\001\007\001\033\001\034\001\032\001\033\001\034\001\
\013\001\039\001\001\001\002\001\003\001\018\001\025\001\025\001\
\016\001\001\001\002\001\003\001\004\001\005\001\006\001\007\001\
\002\001\025\001\037\001\032\001\038\001\013\001\115\000\036\001\
\031\001\038\001\018\001\040\001\041\001\037\001\037\001\033\001\
\034\001\032\001\042\001\037\001\129\000\036\001\160\000\038\001\
\032\001\001\001\164\000\019\001\036\001\040\001\038\001\038\001\
\040\001\042\001\001\001\002\001\003\001\004\001\005\001\148\000\
\007\001\001\001\002\001\003\001\033\001\034\001\013\001\033\001\
\034\001\040\001\022\001\018\001\036\001\042\001\016\001\017\001\
\165\000\009\001\018\001\031\001\032\001\033\001\034\001\035\001\
\043\001\032\001\161\000\162\000\002\001\036\001\010\001\038\001\
\032\001\040\001\016\001\017\001\036\001\008\001\038\001\036\001\
\022\001\023\001\044\001\045\001\046\001\047\001\048\001\049\001\
\002\001\031\001\032\001\033\001\034\001\035\001\036\001\001\001\
\038\001\002\001\043\001\029\001\042\001\037\001\044\001\045\001\
\046\001\047\001\048\001\049\001\016\001\017\001\022\001\037\001\
\033\001\034\001\022\001\017\001\037\001\025\001\039\001\002\001\
\042\001\042\001\025\001\031\001\032\001\033\001\034\001\035\001\
\025\001\037\001\038\001\042\001\042\001\037\001\042\001\031\001\
\044\001\045\001\046\001\047\001\048\001\049\001\044\001\045\001\
\046\001\047\001\048\001\049\001\016\001\017\001\041\001\016\001\
\017\001\045\001\046\001\047\001\048\001\025\001\043\001\002\001\
\025\001\001\001\002\001\003\001\004\001\005\001\006\001\007\001\
\001\001\037\001\000\000\042\001\037\001\013\001\042\001\037\001\
\037\001\042\001\018\001\044\001\045\001\046\001\047\001\048\001\
\049\001\037\001\037\001\037\001\016\001\017\001\131\000\036\000\
\032\001\022\000\138\000\255\255\036\001\025\001\038\001\255\255\
\040\001\041\001\255\255\031\001\032\001\033\001\034\001\035\001\
\255\255\037\001\038\001\255\255\255\255\255\255\042\001\255\255\
\044\001\045\001\046\001\047\001\048\001\049\001\016\001\017\001\
\033\001\034\001\255\255\255\255\037\001\255\255\039\001\025\001\
\255\255\042\001\255\255\255\255\255\255\031\001\032\001\033\001\
\034\001\035\001\255\255\037\001\038\001\255\255\255\255\255\255\
\042\001\255\255\044\001\045\001\046\001\047\001\048\001\049\001\
\016\001\017\001\033\001\034\001\255\255\255\255\037\001\255\255\
\039\001\025\001\255\255\042\001\255\255\255\255\255\255\031\001\
\032\001\033\001\034\001\035\001\255\255\037\001\038\001\255\255\
\255\255\255\255\042\001\255\255\044\001\045\001\046\001\047\001\
\048\001\049\001\016\001\017\001\044\001\045\001\046\001\047\001\
\048\001\049\001\255\255\025\001\255\255\255\255\255\255\255\255\
\255\255\031\001\032\001\255\255\016\001\017\001\255\255\037\001\
\038\001\255\255\255\255\255\255\042\001\025\001\044\001\045\001\
\046\001\047\001\048\001\049\001\016\001\017\001\255\255\255\255\
\255\255\037\001\255\255\255\255\255\255\025\001\042\001\255\255\
\255\255\255\255\255\255\031\001\032\001\255\255\016\001\017\001\
\255\255\037\001\038\001\255\255\255\255\255\255\042\001\025\001\
\044\001\045\001\046\001\047\001\048\001\049\001\016\001\017\001\
\255\255\255\255\255\255\037\001\038\001\255\255\255\255\025\001\
\042\001\255\255\044\001\045\001\046\001\047\001\048\001\049\001\
\016\001\017\001\255\255\037\001\255\255\255\255\016\001\017\001\
\255\255\025\001\044\001\045\001\046\001\047\001\048\001\049\001\
\255\255\255\255\255\255\016\001\017\001\037\001\255\255\255\255\
\255\255\016\001\017\001\037\001\044\001\045\001\046\001\047\001\
\048\001\049\001\044\001\045\001\046\001\047\001\048\001\049\001\
\037\001\255\255\255\255\255\255\255\255\255\255\037\001\044\001\
\045\001\046\001\047\001\048\001\049\001\044\001\045\001\046\001\
\047\001\048\001\049\001\016\001\017\001\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\025\001\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\037\001\255\255\255\255\255\255\255\255\042\001"

let yynames_const = "\
  CLASS\000\
  DEF\000\
  RETURN\000\
  IF\000\
  ELSE\000\
  IN\000\
  RELATION\000\
  TYPE\000\
  COMMENT\000\
  FOR\000\
  FALSE\000\
  TRUE\000\
  LOG_AND\000\
  LOG_OR\000\
  LOG_NOT\000\
  NAME\000\
  VECTOR\000\
  SCALAR\000\
  CROSS\000\
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
  BOUNDARY\000\
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
  IDENT\000\
  STRING\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'sentence_list) in
    Obj.repr(
# 59 "ocaml/pdsl_parser.mly"
 (0)
# 461 "ocaml/pdsl_parser.ml"
               : int))
; (fun __caml_parser_env ->
    Obj.repr(
# 63 "ocaml/pdsl_parser.mly"
  ()
# 467 "ocaml/pdsl_parser.ml"
               : 'sentence_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'sentence_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'sentence) in
    Obj.repr(
# 64 "ocaml/pdsl_parser.mly"
                          ()
# 475 "ocaml/pdsl_parser.ml"
               : 'sentence_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'class_def) in
    Obj.repr(
# 69 "ocaml/pdsl_parser.mly"
             ()
# 482 "ocaml/pdsl_parser.ml"
               : 'sentence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'func_def) in
    Obj.repr(
# 70 "ocaml/pdsl_parser.mly"
            ()
# 489 "ocaml/pdsl_parser.ml"
               : 'sentence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'single_sentence) in
    Obj.repr(
# 71 "ocaml/pdsl_parser.mly"
                   ()
# 496 "ocaml/pdsl_parser.ml"
               : 'sentence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'basic_class_def) in
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'maybe_name) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'maybe_relation) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'single_assign_list) in
    Obj.repr(
# 82 "ocaml/pdsl_parser.mly"
     ()
# 506 "ocaml/pdsl_parser.ml"
               : 'class_def))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 87 "ocaml/pdsl_parser.mly"
 (
		class_table := (Stringmap.add _2 func_cnt class_table.contents);
		curr_name := _2
	)
# 516 "ocaml/pdsl_parser.ml"
               : 'basic_class_def))
; (fun __caml_parser_env ->
    Obj.repr(
# 93 "ocaml/pdsl_parser.mly"
 (
		print_endline (curr_idtstr.contents ^ "Phymanager.add_var('" ^ curr_name.contents ^ "',None)")
	)
# 524 "ocaml/pdsl_parser.ml"
               : 'maybe_name))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 97 "ocaml/pdsl_parser.mly"
 (
		print_endline (curr_idtstr.contents ^ "Phymanager.add_var('" ^ curr_name.contents ^ "','" ^ _3 ^ "')")
	)
# 533 "ocaml/pdsl_parser.ml"
               : 'maybe_name))
; (fun __caml_parser_env ->
    Obj.repr(
# 102 "ocaml/pdsl_parser.mly"
 ()
# 539 "ocaml/pdsl_parser.ml"
               : 'maybe_relation))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'relation_exp) in
    Obj.repr(
# 104 "ocaml/pdsl_parser.mly"
 (
		tmp := "{";
		Stringmap.iter addstring _3;
		tmp := tmp.contents ^ "}";
		(*what is the API?*)
		print_endline (curr_idtstr.contents ^ "Phymanager.add_relation('" ^ curr_name.contents ^ "'," ^ tmp.contents ^ ")")
		(*I suppose that's not correct*)
	)
# 553 "ocaml/pdsl_parser.ml"
               : 'maybe_relation))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'relation_exp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'relation) in
    Obj.repr(
# 116 "ocaml/pdsl_parser.mly"
 (
		Stringmap.merge add _1 _3
	)
# 563 "ocaml/pdsl_parser.ml"
               : 'relation_exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'relation_exp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'relation) in
    Obj.repr(
# 120 "ocaml/pdsl_parser.mly"
 (
		Stringmap.merge sub1 _1 _3
	)
# 573 "ocaml/pdsl_parser.ml"
               : 'relation_exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'relation) in
    Obj.repr(
# 124 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 582 "ocaml/pdsl_parser.ml"
               : 'relation_exp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'relation_exp) in
    Obj.repr(
# 131 "ocaml/pdsl_parser.mly"
 (
		_2
	)
# 591 "ocaml/pdsl_parser.ml"
               : 'relation))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'relation) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ct2) in
    Obj.repr(
# 135 "ocaml/pdsl_parser.mly"
 (
		Stringmap.map (mult _3) _1
	)
# 601 "ocaml/pdsl_parser.ml"
               : 'relation))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 139 "ocaml/pdsl_parser.mly"
 (
		Stringmap.add _1 1.0 Stringmap.empty
	)
# 610 "ocaml/pdsl_parser.ml"
               : 'relation))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ct1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'single_const_exp) in
    Obj.repr(
# 146 "ocaml/pdsl_parser.mly"
 (_1 +. _3)
# 618 "ocaml/pdsl_parser.ml"
               : 'single_const_exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ct2) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'single_const_exp) in
    Obj.repr(
# 148 "ocaml/pdsl_parser.mly"
 (_1 -. _3)
# 626 "ocaml/pdsl_parser.ml"
               : 'single_const_exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ct1) in
    Obj.repr(
# 149 "ocaml/pdsl_parser.mly"
       (_1)
# 633 "ocaml/pdsl_parser.ml"
               : 'single_const_exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ct2) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ct1) in
    Obj.repr(
# 153 "ocaml/pdsl_parser.mly"
 (_1 *. _3)
# 641 "ocaml/pdsl_parser.ml"
               : 'ct1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ct2) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ct1) in
    Obj.repr(
# 155 "ocaml/pdsl_parser.mly"
 (_1 /. _3)
# 649 "ocaml/pdsl_parser.ml"
               : 'ct1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ct2) in
    Obj.repr(
# 156 "ocaml/pdsl_parser.mly"
       (_1)
# 656 "ocaml/pdsl_parser.ml"
               : 'ct1))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'single_const_exp) in
    Obj.repr(
# 159 "ocaml/pdsl_parser.mly"
 (_2)
# 663 "ocaml/pdsl_parser.ml"
               : 'ct2))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ct2) in
    Obj.repr(
# 161 "ocaml/pdsl_parser.mly"
 (-._2)
# 670 "ocaml/pdsl_parser.ml"
               : 'ct2))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 163 "ocaml/pdsl_parser.mly"
 (float_of_string _1)
# 677 "ocaml/pdsl_parser.ml"
               : 'ct2))
; (fun __caml_parser_env ->
    Obj.repr(
# 166 "ocaml/pdsl_parser.mly"
   ()
# 683 "ocaml/pdsl_parser.ml"
               : 'single_assign_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'single_assign_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'single_assign) in
    Obj.repr(
# 168 "ocaml/pdsl_parser.mly"
 (
		print_endline (curr_idtstr.contents ^ _2)
	)
# 693 "ocaml/pdsl_parser.ml"
               : 'single_assign_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 175 "ocaml/pdsl_parser.mly"
 (
		"Phymanager.add_subunit('" ^ _2 ^ "','" ^ _5 ^ "'," ^ string_of_float((float_of_string _4) /. (float_of_string _1)) ^ ")"
	)
# 705 "ocaml/pdsl_parser.ml"
               : 'single_assign))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'basic_func_def) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'code_block_return) in
    Obj.repr(
# 185 "ocaml/pdsl_parser.mly"
 ()
# 713 "ocaml/pdsl_parser.ml"
               : 'func_def))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'para_list) in
    Obj.repr(
# 190 "ocaml/pdsl_parser.mly"
 (
		print_endline (curr_idtstr.contents ^ "def " ^ _2 ^ "(" ^ _4 ^ ")")
	)
# 723 "ocaml/pdsl_parser.ml"
               : 'basic_func_def))
; (fun __caml_parser_env ->
    Obj.repr(
# 196 "ocaml/pdsl_parser.mly"
 (
		""
	)
# 731 "ocaml/pdsl_parser.ml"
               : 'para_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'non_empty_para_list) in
    Obj.repr(
# 200 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 740 "ocaml/pdsl_parser.ml"
               : 'para_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'non_empty_para_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'para) in
    Obj.repr(
# 207 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "," ^ _3
	)
# 750 "ocaml/pdsl_parser.ml"
               : 'non_empty_para_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'para) in
    Obj.repr(
# 211 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 759 "ocaml/pdsl_parser.ml"
               : 'non_empty_para_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 218 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 768 "ocaml/pdsl_parser.ml"
               : 'para))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'code_block) in
    Obj.repr(
# 224 "ocaml/pdsl_parser.mly"
              ()
# 775 "ocaml/pdsl_parser.ml"
               : 'single_sentence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'branch) in
    Obj.repr(
# 225 "ocaml/pdsl_parser.mly"
          ()
# 782 "ocaml/pdsl_parser.ml"
               : 'single_sentence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'recurr) in
    Obj.repr(
# 226 "ocaml/pdsl_parser.mly"
          ()
# 789 "ocaml/pdsl_parser.ml"
               : 'single_sentence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'exp) in
    Obj.repr(
# 228 "ocaml/pdsl_parser.mly"
 (
		print_endline (curr_idtstr.contents ^ _1)
	)
# 798 "ocaml/pdsl_parser.ml"
               : 'single_sentence))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'lcp_addident) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'sentence_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'rcp_subident) in
    Obj.repr(
# 238 "ocaml/pdsl_parser.mly"
 ()
# 807 "ocaml/pdsl_parser.ml"
               : 'code_block))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'lcp_addident) in
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'sentence_list) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'rcp_subident) in
    Obj.repr(
# 246 "ocaml/pdsl_parser.mly"
 ()
# 816 "ocaml/pdsl_parser.ml"
               : 'code_block_return))
; (fun __caml_parser_env ->
    Obj.repr(
# 250 "ocaml/pdsl_parser.mly"
 (
		indent_cnt := indent_cnt.contents + 1;
		curr_idtstr := curr_idtstr.contents ^ "\t";
	)
# 825 "ocaml/pdsl_parser.ml"
               : 'lcp_addident))
; (fun __caml_parser_env ->
    Obj.repr(
# 257 "ocaml/pdsl_parser.mly"
 (
		indent_cnt := indent_cnt.contents - 1;
		if indent_cnt.contents < 0 
		then Printf.eprintf "bad indent"
		else 
		curr_idtstr := String.sub curr_idtstr.contents 1 indent_cnt.contents
	)
# 837 "ocaml/pdsl_parser.ml"
               : 'rcp_subident))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'basic_branch_if) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'code_block) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'basic_else) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'code_block) in
    Obj.repr(
# 270 "ocaml/pdsl_parser.mly"
            ()
# 847 "ocaml/pdsl_parser.ml"
               : 'branch))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'basic_branch_if) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'code_block) in
    Obj.repr(
# 272 "ocaml/pdsl_parser.mly"
            ()
# 855 "ocaml/pdsl_parser.ml"
               : 'branch))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 't1) in
    Obj.repr(
# 277 "ocaml/pdsl_parser.mly"
 (
			print_endline (curr_idtstr.contents ^ "if " ^ _3 ^ ":")
	)
# 864 "ocaml/pdsl_parser.ml"
               : 'basic_branch_if))
; (fun __caml_parser_env ->
    Obj.repr(
# 282 "ocaml/pdsl_parser.mly"
 (
		print_endline (curr_idtstr.contents ^ "else:")
	)
# 872 "ocaml/pdsl_parser.ml"
               : 'basic_else))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'basic_recurr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'code_block) in
    Obj.repr(
# 288 "ocaml/pdsl_parser.mly"
             ()
# 880 "ocaml/pdsl_parser.ml"
               : 'recurr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'interval) in
    Obj.repr(
# 293 "ocaml/pdsl_parser.mly"
  (
			print_endline (curr_idtstr.contents ^ "for " ^ _2 ^ " in " ^ _4 ^ ":")
		)
# 890 "ocaml/pdsl_parser.ml"
               : 'basic_recurr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 't1) in
    Obj.repr(
# 300 "ocaml/pdsl_parser.mly"
 (
		"range(" ^ _2 ^ ")"
	)
# 899 "ocaml/pdsl_parser.ml"
               : 'interval))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 't1) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 't1) in
    Obj.repr(
# 304 "ocaml/pdsl_parser.mly"
 (
		"range(" ^ _2 ^ "," ^ _4 ^ ")"
	)
# 909 "ocaml/pdsl_parser.ml"
               : 'interval))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 't1) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 't1) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 't1) in
    Obj.repr(
# 308 "ocaml/pdsl_parser.mly"
 (
		"range(" ^ _2 ^ "," ^ _4 ^ "," ^ _6 ^ ")"
	)
# 920 "ocaml/pdsl_parser.ml"
               : 'interval))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'exp) in
    Obj.repr(
# 315 "ocaml/pdsl_parser.mly"
 (
		var_table := Stringmap.add _1 func_cnt.contents var_table.contents;
		print_endline (_1 ^ ".set_val(" ^ assgin_value.contents ^ ")");
		(*$1 ^ " = " ^ $3*)
	)
# 932 "ocaml/pdsl_parser.ml"
               : 'exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 321 "ocaml/pdsl_parser.mly"
 (
		assgin_value := _1;
		_1
	)
# 942 "ocaml/pdsl_parser.ml"
               : 'exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 329 "ocaml/pdsl_parser.mly"
 (
		_1 ^ " and " ^ _3
	)
# 952 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 333 "ocaml/pdsl_parser.mly"
 (
		_1 ^ " or " ^ _3
	)
# 962 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 337 "ocaml/pdsl_parser.mly"
 (
		"not " ^ _2
	)
# 971 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 341 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "==" ^ _3
	)
# 981 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 345 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "!=" ^ _3
	)
# 991 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 349 "ocaml/pdsl_parser.mly"
 (
		_1 ^ ">" ^ _3
	)
# 1001 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 353 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "<" ^ _3
	)
# 1011 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 357 "ocaml/pdsl_parser.mly"
 (
		_1 ^ ">=" ^ _3
	)
# 1021 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 361 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "<=" ^ _3
	)
# 1031 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 't2) in
    Obj.repr(
# 365 "ocaml/pdsl_parser.mly"
    (
        _1
    )
# 1040 "ocaml/pdsl_parser.ml"
               : 't1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 't2) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'relation_exp) in
    Obj.repr(
# 372 "ocaml/pdsl_parser.mly"
 (
		tmp := "{";
		Stringmap.iter addstring _3;
		tmp := tmp.contents ^ "}";
		(*what is the API?*)
		(*I suppose that's not correct*)
		"PhyVar(" ^ _1 ^ "," ^ tmp.contents ^ ",True)"
	)
# 1055 "ocaml/pdsl_parser.ml"
               : 't2))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 't3) in
    Obj.repr(
# 380 "ocaml/pdsl_parser.mly"
      (_1)
# 1062 "ocaml/pdsl_parser.ml"
               : 't2))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't3) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't3) in
    Obj.repr(
# 385 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "+" ^ _3
	)
# 1072 "ocaml/pdsl_parser.ml"
               : 't3))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't3) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't3) in
    Obj.repr(
# 389 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "-" ^ _3
	)
# 1082 "ocaml/pdsl_parser.ml"
               : 't3))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't3) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't3) in
    Obj.repr(
# 393 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "%" ^ _3
	)
# 1092 "ocaml/pdsl_parser.ml"
               : 't3))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't3) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't3) in
    Obj.repr(
# 397 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "*" ^ _3
	)
# 1102 "ocaml/pdsl_parser.ml"
               : 't3))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't3) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't3) in
    Obj.repr(
# 401 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "/" ^ _3
	)
# 1112 "ocaml/pdsl_parser.ml"
               : 't3))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't3) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't3) in
    Obj.repr(
# 405 "ocaml/pdsl_parser.mly"
 (
		_1 ^ ".cross(" ^ _3 ^ ")"
	)
# 1122 "ocaml/pdsl_parser.ml"
               : 't3))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 't3) in
    Obj.repr(
# 409 "ocaml/pdsl_parser.mly"
 (
		"-" ^ _2
	)
# 1131 "ocaml/pdsl_parser.ml"
               : 't3))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 't4) in
    Obj.repr(
# 412 "ocaml/pdsl_parser.mly"
         (_1)
# 1138 "ocaml/pdsl_parser.ml"
               : 't3))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 't4) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 417 "ocaml/pdsl_parser.mly"
    (
        _1 ^ "." ^ _3
    )
# 1148 "ocaml/pdsl_parser.ml"
               : 't4))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 't4) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'p_list) in
    Obj.repr(
# 421 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "(" ^ _3 ^ ")"
 	)
# 1158 "ocaml/pdsl_parser.ml"
               : 't4))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 't1) in
    Obj.repr(
# 425 "ocaml/pdsl_parser.mly"
 (
		"(" ^ _2 ^ ")"
	)
# 1167 "ocaml/pdsl_parser.ml"
               : 't4))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'var) in
    Obj.repr(
# 429 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 1176 "ocaml/pdsl_parser.ml"
               : 't4))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'num_exp) in
    Obj.repr(
# 436 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 1185 "ocaml/pdsl_parser.ml"
               : 'var))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 440 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 1194 "ocaml/pdsl_parser.ml"
               : 'var))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 444 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 1203 "ocaml/pdsl_parser.ml"
               : 'var))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 451 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 1212 "ocaml/pdsl_parser.ml"
               : 'num_exp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'num_list) in
    Obj.repr(
# 455 "ocaml/pdsl_parser.mly"
 (
		"(" ^ _2 ^ ")"
	)
# 1221 "ocaml/pdsl_parser.ml"
               : 'num_exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 462 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 1230 "ocaml/pdsl_parser.ml"
               : 'num_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'num_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 466 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "," ^ _3
	)
# 1240 "ocaml/pdsl_parser.ml"
               : 'num_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 473 "ocaml/pdsl_parser.mly"
 (
		""
	)
# 1248 "ocaml/pdsl_parser.ml"
               : 'p_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'non_empty_p_list) in
    Obj.repr(
# 477 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 1257 "ocaml/pdsl_parser.ml"
               : 'p_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 484 "ocaml/pdsl_parser.mly"
 (
		_1
	)
# 1266 "ocaml/pdsl_parser.ml"
               : 'non_empty_p_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'non_empty_p_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 't1) in
    Obj.repr(
# 488 "ocaml/pdsl_parser.mly"
 (
		_1 ^ "," ^ _3
	)
# 1276 "ocaml/pdsl_parser.ml"
               : 'non_empty_p_list))
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
;;
