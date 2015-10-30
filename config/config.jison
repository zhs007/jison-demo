/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
"+"                   return "PLUS"
"-"                   return "MINUS"
"*"                   return "MULTIPLE"
"/"                   return "DIVIDE"
"("                   return "LP"
")"                   return "RP"
"="                   return "DD"
[0-9]+("."[0-9]+)?    return 'NUMBER'
[a-z]+("_"[0-9a-z]+)? return 'WORD'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

%start expressions

%% /* language grammar */

expressions
    : statementex EOF
        {
        console.log($1);
        return $1;
        }
    ;

statementex:
  statement DD statement {$$ = {name: $1, val: $3}}
  ;

statement:
  term PLUS term {$$ = $1 + $3}
  |
  term MINUS term {$$ = $1 - $3}
  |
  term {$$ = $1}
  ;

term:
  factor MULTIPLE factor {$$ = $1 * $3}
  |
  factor DIVIDE factor {$$ = $1 / $3}
  |
  factor {$$ = $1}
  ;

factor:
  NUMBER {$$ = parseFloat($1)}
  |
  WORD {$$ = $1}
  |
  LP statement RP {$$ = $2}
  ;
