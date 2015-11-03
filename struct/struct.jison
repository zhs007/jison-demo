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
";"                   return "SEMI"
"struct"              return "STRUCT"
"{"                   return "LB"
"}"                   return "RB"
"string"              return "TYPE_STRING"
"int"                 return "TYPE_INT"
[0-9]+("."[0-9]+)?    return 'NUMBER'
[_a-zA-Z]+("_"[0-9a-zA-Z]+)? return 'WORD'
\"[^\"]*\"|\'[^\']*\' return 'STRING'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

%{
  var mapval = {};

  function addVal(o) {
    mapval[o.name] = o;

    return o;
  }

  function getVal(objname) {
    if (mapval.hasOwnProperty(objname)) {
      return mapval[objname].val;
    }

    return 0;
  }
%}

%start expressions

%% /* language grammar */

expressions
    : block EOF
        {
        return $1;
        }
    ;

block:
  blocknode {$$ = [$1]}
  |
  blocknode block {$2.push($1); $$ = $2}
  ;

blocknode:
  lineblock COMMENTLINE {addVal($1); $1.comment = $2; $$ = $1}
  |
  COMMENTLINE structblock {$2.comment = $1; $$ = $2}
  ;

lineblock:
  deflineex {$$ = $1}
  ;

structblock:
  STRUCT WORD LB structinfo RB SEMI {$$ = {type: 'struct', val: $4, name: $2}}
  ;

structinfo:
  defline SEMI {$$ = [$1]}
  |
  defline SEMI COMMENTLINE {$1.comment = $3; $$ = [$1]}
  |
  defline SEMI structinfo {$3.push($1); $$ = $3}
  |
  defline SEMI COMMENTLINE structinfo {$1.comment = $3; $4.push($1); $$ = $4}
  ;

deflineex:
  defline SEMI {$$ = $1}
  ;

defline:
  TYPE_INT WORD {$$ = {type: 'int', name: $2, val: 0}}
  |
  TYPE_INT WORD EQU statement {$$ = {type: 'int', name: $2, val: $4}}
  |
  TYPE_STRING WORD {$$ = {type: 'string', name: $2, val: ''}}
  |
  TYPE_STRING WORD EQU statement {$$ = {type: 'string', name: $2, val: $4}}
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
  WORD {$$ = getVal($1)}
  |
  STRING {$$ = $1.slice(1, -1)}
  |
  LP statement RP {$$ = $2}
  ;
