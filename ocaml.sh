!#/bin/bash
ocamllex pdsl_lexer.mll
ocamlyacc pdsl_parser.mly
ocamlc -c pdsl_parser.mli
ocamlc -c pdsl_lexer.ml
ocamlc -c pdsl_parser.ml
ocamlc -c pdsl.ml
ocamlc -o PDSL pdsl_lexer.cmo pdsl_parser.cmo pdsl.cmo