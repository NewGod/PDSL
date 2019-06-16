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

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> int
