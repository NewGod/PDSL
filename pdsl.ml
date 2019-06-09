let _ =
          try
            let lexbuf = Lexing.from_channel stdin in
            while true do
              let result = Pdsl_parser.main Pdsl_lexer.token lexbuf 
              			in
          	(*in print_int result; print_newline();*) flush stdout
            done
          with Pdsl_lexer.Eof ->
            exit 0