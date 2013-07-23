%{
#include <cstdio>
#include "scanner.hpp"
#include "SymbolTable.hpp"

// int yyerror(const char* s)
extern int line;
extern char* yytext;

// Prototypes
int yyerror(const char *);

// Globals
SymbolTable st;
%}

%output "src/parser.cpp"

%union {
	int INT;
	char TEXT[64];
}

%token T_ODD
%token T_BEGIN T_END
%token T_IF T_THEN
%token T_WHILE T_DO
%token T_PROCEDURE T_CALL
%token T_VAR T_CONST T_ASSIGN
%token T_EQ T_HASH T_LT T_LE T_GT T_GE
%token T_ADD T_SUB T_MUL T_DIV
%token T_BRO T_BRC
%token T_COMMA T_SEMICOLON T_DOT
%token T_READ T_WRITE T_DEBUG

%token<TEXT> T_IDENT
%token<INT> T_NUMBER

%%
program				: block T_DOT
					;

block				:   {
							st.levelUp();
						}
					  const_decl var_decl procedure_list statement
						{
							static int show = 1;

							if (show)				// DEBUG
								st.print();	show--;	// DEBUG
							st.levelDown();
						}
					;

/* CONST */
const_decl			: /*E*/
					| T_CONST const_list T_SEMICOLON
					;

const_list			: T_IDENT T_EQ T_NUMBER
						{
							st.insert($1, CONST);
						}
					| T_IDENT T_EQ T_NUMBER T_COMMA
						{
							st.insert($1, CONST);
						}
					  const_list
					;

/* VAR */
var_decl			: /*E*/
					| T_VAR var_list T_SEMICOLON
					;

var_list			: T_IDENT
						{
							st.insert($1, VAR);
						}
					| T_IDENT T_COMMA 
						{
							st.insert($1, VAR);
						} 
					  var_list
					;

/* PROCEDURE */
procedure_list		: /*E*/
					| procedure T_SEMICOLON procedure_list
					;

procedure			: T_PROCEDURE T_IDENT 
						{
							st.insert($2, PROC);
						}
					  T_SEMICOLON block
					;

/* STATEMENT */
statement 			: /*E*/
					| T_IDENT T_ASSIGN expression
					| T_CALL T_IDENT
					| T_BEGIN statement_list T_END
					| T_IF condition T_THEN statement
					| T_WHILE condition T_DO statement
					| T_DEBUG
					| T_READ T_IDENT
					| T_WRITE expression
					;

statement_list		: statement
					| statement T_SEMICOLON statement_list
					;

/* CONDITION */
condition			: T_ODD expression
					| expression T_EQ expression
					| expression T_HASH expression
					| expression T_LT expression
					| expression T_LE expression
					| expression T_GT expression
					| expression T_GE expression
					;

/* EXPRESSION */
expression 			: term
					| expression T_ADD term
					| expression T_SUB term
					;

/* TERM */
term 				: factor
					| term T_MUL factor
					| term T_DIV factor
					;

/* FACTOR */
factor  			: T_IDENT
					| T_NUMBER
					| T_BRO expression T_BRC
					| T_ADD factor
					| T_SUB factor
					;
%%

int yyerror(const char* s) {
    fprintf(stderr, "Error in line %d: %s (before token '%s')\n", line, s, yytext);
    return -1;
}
