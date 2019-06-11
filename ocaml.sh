#!/bin/bash
rm -rf bin/ 
mkdir bin/
rm -rf build/
mkdir build/
cd build/
ocamllex ../ocaml/pdsl_lexer.mll -o pdsl_lexer.ml
menhir ../ocaml/pdsl_parser.mly --base pdsl_parser
ocamlc -c pdsl_parser.mli
ocamlc -c pdsl_lexer.ml
ocamlc -c pdsl_parser.ml
ocamlc -c ../ocaml/pdsl.ml -o pdsl.cmo
ocamlc -o ../bin/pdsl pdsl_lexer.cmo pdsl_parser.cmo pdsl.cmo
