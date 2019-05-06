{
		open Parser
        open Printf
        exception Eof
}

let letter = ['a'-'z' 'A'-'Z']
let ident = ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']*

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

let num = int | float


rule token = parse
whitespace {token lexbuf} 
| newline {NEWLINE}
| "class" {printf("class ");CLASS} 
| "def" {printf("def ");DEF} 
| "return" {printf("return ");RETURN} 
| "if" {printf("if ");IF} 
| "in" {printf("in ");IN}
| "for" {printf("for ");FOR} 
| "false" {printf("false ");FALSE}
| "true" {printf("true ");TRUE} 
| "and" {printf("and ");LOG_AND}
| "or" {printf("or ");LOG_OR} 
| "not" {printf("not ");LOG_NOT}
| "relation" {printf("relation ");RELATION}
| "type" {printf("type ");TYPE}
| "name" {printf("name ");NAME}
| "vector" {printf("vector ");VECTOR} 
| "scalar" {printf("scalar ");SCALAR}
| "cross" {printf("cross ");CROSS}
| string {printf("string ");STRING}
| ident {printf("ident ");IDENT}
| num {printf("num ");NUM} 
| ":" {printf("COLON ");COLON}
| ";" {printf "BOUNDARY ";BOUNDARY}
| "." {printf("DOT ");DOT} 
| "," {printf("COMMA ");COMMA}
| "=" {printf("ASSIGN ");ASSIGN}
| "==" {printf("EQ ");EQ} 
| "!=" {printf("NEQ ");NEQ} 
| ">=" {printf("GEQ ");GEQ} 
| "<=" {printf("LEQ ");LEQ} 
| ">" {printf("GT ");GT} 
| "<" {printf("LE ");LE} 
| "!" {printf("NOT ");NOT} 
| "**" {printf("POWER ");POWER}
| "^" {printf("XOR ");XOR}
| "&" {printf("class ");AND} 

| "+" {printf("PLUS ");PLUS} 
| "-" {printf("MINUS ");MINUS} 
| "*" {printf("MULTI ");MULTI} 
| "/" {printf("DIV ");DIV}
| "%" {printf("MOD ");MOD}

| "#" {printf("COMMENT ");COMMENT} 

| "(" {printf("LP ");LP} 
| ")" {printf("RP ");RP} 
| "{" {printf("LCP ");LCP}
| "}" {printf("RCP ");RCP}
| "[" {printf("LMP ");LMP} 
| "]" {printf("RMP ");RMP} 
| eof {raise Eof}

(*rule token = parse
whitespace {token lexbuf} 
| "class" {printf("class ");token lexbuf} 
| "def" {printf("def ");token lexbuf} 
| "return" {printf("return ");token lexbuf} 
| "if" {printf("if ");token lexbuf} 
| "in" {printf("in ");token lexbuf}
| "for" {printf("for ");token lexbuf} 
| "false" {printf("false ");token lexbuf}
| "true" {printf("true ");token lexbuf} 
| "and" {printf("and ");token lexbuf}
| "or" {printf("or ");token lexbuf} 
| "not" {printf("not ");token lexbuf}
| "relation" {printf("relation ");token lexbuf}
| "type" {printf("type ");token lexbuf}
| "name" {printf("name ");token lexbuf}
| "vector" {printf("vector ");token lexbuf} 
| "scalar" {printf("scalar ");token lexbuf}
| "cross" {printf("cross ");token lexbuf}
| string {printf("string ");token lexbuf}
| ident {printf("ident ");token lexbuf}
| num {printf("num ");token lexbuf} 
| newline {printf "newline"; token lexbuf}
| ":" {printf("COLON ");token lexbuf}
| "." {printf("DOT ");token lexbuf} 
| "," {printf("COMMA ");token lexbuf}
| "=" {printf("ASSIGN ");token lexbuf}
| "==" {printf("EQ ");token lexbuf} 
| "!=" {printf("NEQ ");token lexbuf} 
| ">=" {printf("GEQ ");token lexbuf} 
| "<=" {printf("LEQ ");token lexbuf} 
| ">" {printf("GT ");token lexbuf} 
| "<" {printf("LE ");token lexbuf} 
| "!" {printf("NOT ");token lexbuf} 
| "**" {printf("POWER ");token lexbuf}
| "^" {printf("XOR ");token lexbuf}
| "&" {printf("class ");token lexbuf} 

| "+" {printf("PLUS ");token lexbuf} 
| "-" {printf("MINUS ");token lexbuf} 
| "*" {printf("MULTI ");token lexbuf} 
| "/" {printf("DIV ");token lexbuf}
| "%" {printf("MOD ");token lexbuf}

| "#" {printf("COMMENT ");token lexbuf} 

| "(" {printf("LP ");token lexbuf} 
| ")" {printf("RP ");token lexbuf} 
| "{" {printf("LCP ");token lexbuf}
| "}" {printf("RCP ");token lexbuf}
| "[" {printf("LMP ");token lexbuf} 
| "]" {printf("RMP ");token lexbuf} 
| eof {raise Eof}*)

