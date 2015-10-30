/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
\n|\r\n               /* skip whitespace */
\/\/[^\n]*            return "COMMENTLINE"
"+"                   return "PLUS"
"-"                   return "MINUS"
"*"                   return "MULTIPLE"
\/[^\/]               return "DIVIDE"
"("                   return "LP"
")"                   return "RP"
"="                   return "EQU"
[0-9]+("."[0-9]+)?    return 'NUMBER'
[a-zA-Z]+("_"[0-9a-zA-Z]+)? return 'WORD'
\"[^\"]*\"            return 'STRING'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

%{
  function addComment(obj, comment) {
    obj.comment = comment.replace('\r', '').slice(2);
    return obj;
  }

  function merge(o1, o2) {
    var arr = [];

    if (o1 instanceof Array) {
      for(var k in o1) {
        arr.push(o1[k]);
      }
    }
    else {
      arr.push(o1);
    }

    arr.push(o2);

    return arr;
  }
%}

%start expressions

%% /* language grammar */

expressions
    : block EOF
        {
        console.log($1);
        return $1;
        }
    ;

block:
  statementexline {$$ = $1}
  |
  block statementexline {$$ = merge($1, $2)}
  ;

statementexline:
  statementex COMMENTLINE {$$ = addComment($1, $2)}
  |
  statementex {$$ = $1}
  ;

statementex:
  statement EQU statement {$$ = {name: $1, val: $3}}
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
  STRING {$$ = $1.slice(1, -1)}
  |
  LP statement RP {$$ = $2}
  ;
