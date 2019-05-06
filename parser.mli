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

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> int
