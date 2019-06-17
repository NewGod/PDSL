{
		open Pdsl_parser
        open Printf
        exception Eof
}

let letter = ['a'-'z' 'A'-'Z']
let ident = (['a'-'z' 'A'-'Z' '_'])(['a'-'z' 'A'-'Z' '0'-'9' '_'])*

let digit = ['0'-'9']
let int = digit+
let frac = '.' digit+
let exp = ['e' 'E']['-' '+']?digit+
let float = digit*frac+ exp?

let longbyteschar  =  [^ '\\']
let bytesescapeseq =  '\\' _
let longbytesitem  =  longbyteschar | bytesescapeseq
let shortbytes     =  (['\'' '\"'])([^ '\'' '\"' '\r' '\n']|bytesescapeseq)*? (['\'' '\"'])
let longbytes      =  "'''" longbytesitem*? "'''" | "\"\"\"" longbytesitem*? "\"\"\""

let whitespace = [' ' '\t' '\r' '\n']+
let string = shortbytes | longbytes
let newline = '\n'
let num = int | float
let comment = "#" ([^ '\r' '\n']|bytesescapeseq)* "\n"


rule token = parse
whitespace {token lexbuf} 
| "class" {CLASS} 
| "def" {DEF} 
| "return" {RETURN} 
| "if" {IF} 
| "else" {ELSE}
| "in" {IN}
| "for" {FOR} 
| "false" {FALSE}
| "true" {TRUE} 
| "and" {LOG_AND}
| "or" {LOG_OR} 
| "not" {LOG_NOT}
| "relation" {RELATION}
| "type" {TYPE}
| "name" {NAME}
| "vector" {VECTOR} 
| "scalar" {SCALAR}
| "cross" {CROSS}
| string as lxm {STRING(lxm)}
| ident as lxm {IDENT(lxm)}
| num as lxm {NUM(lxm)} 
| ":" {COLON}
| ";" {BOUNDARY}
| "." {DOT} 
| "," {COMMA}
| "==" {EQ} 
| "=" {ASSIGN}
| "!=" {NEQ} 
| ">=" {GEQ} 
| "<=" {LEQ} 
| ">" {GT} 
| "<" {LE} 
| "!" {NOT} 
| "**" {POWER}
| "^" {XOR}
| "&" {AND} 

| "+" {PLUS} 
| "-" {MINUS} 
| "*" {MULTI} 
| "/" {DIV}
| "%" {MOD}

| comment {token lexbuf} 

| "(" {LP} 
| ")" {RP} 
| "{" {LCP}
| "}" {RCP}
| "[" {LMP} 
| "]" {RMP} 
| eof {raise Eof}


