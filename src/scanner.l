%{
#include "parser.hpp"

int line = 0;
%}

%option outfile="src/scanner.cpp"
%option header-file="src/scanner.hpp"

%%
"BEGIN"                     return T_BEGIN;
"END"                       return T_END;

"ODD"                       return T_ODD;

"IF"                        return T_IF;
"THEN"                      return T_THEN;

"WHILE"                     return T_WHILE;
"DO"                        return T_DO;

"PROCEDURE"                 return T_PROCEDURE;
"CALL"                      return T_CALL;

"VAR"                       return T_VAR;
"CONST"                     return T_CONST;
":="                        return T_ASSIGN;

"="                         return T_EQ;
"#"                         return T_HASH;
"<"                         return T_LT;
"<="                        return T_LE;
">"                         return T_GT;
">="                        return T_GE;

"+"                         return T_ADD;
"-"                         return T_SUB;
"*"                         return T_MUL;
"/"                         return T_DIV;

"("                         return T_BRO;
")"                         return T_BRC;

"?"                         return T_READ;
"!"                         return T_WRITE;
"DEBUG"                     return T_DEBUG;

","                         return T_COMMA;
";"                         return T_SEMICOLON;
"."                         return T_DOT;

[a-zA-Z]+[a-zA-Z0-9_-]*     strncpy(yylval.TEXT, yytext, 64); return T_IDENT;
[0-9]+                      yylval.INT = atoi(yytext); return T_NUMBER;

[\n]                        line++;
[ \f\t\r]+                  ;
.                           ;
%%
