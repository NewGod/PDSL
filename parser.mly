%token <float> NUM
        %token CLASS DEF RETURN IF IN RELATION TYPE
        %token FOR FALSE TRUE LOG_AND LOG_OR LOG_NOT
        %token NAME VECTOR SCALOR CROSS STRING IDENT
        %token DOT COLON COMMA NOT OR AND POWER XOR
        %token PLUS MINUS MULTI DIV MOD
        %token LP RP LMP RMP LCP RCP
        %token ASSIGN EQ GEQ LEQ GT LE NEQ
        %left PLUS MINUS        /* lowest precedence */
        %left MULTI DIV         /* medium precedence */
        %start main             /* the entry point */
        %type <int> main
        %%

main:
    NUM {}
    ;