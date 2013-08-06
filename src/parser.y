%{
#include <cstdio>
#include "scanner.hpp"
#include "symbolTable.hpp"
#include "ast.hpp"

#define DEBUG_PARSER false

// int yyerror(const char* s)
extern int line;
extern char* yytext;

// Prototypes
int yyerror(const char *);

// Globals
SymbolTable st;
BlockNode *rootNode;
%}

%output "src/parser.cpp"

%union {
    int INT;
    char TEXT[64];
    struct ConstNode *CONST_NODE;
    struct ExprNode *EXPR_NODE;
    struct StmtNode *STMT_NODE;
    struct BlockNode *BLOCK_NODE;
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

%type<CONST_NODE> const_decl const_list
%type<BLOCK_NODE> block procedure procedure_list
%type<INT> var_decl var_list
%type<EXPR_NODE> expression condition term factor
%type<STMT_NODE> statement statement_list


%%
/* (COMPLETE) */
program             : block T_DOT
                        {
                            $1->name = "Root";
                            rootNode = $1;
                        }
                    ;

// NEED TO CHECK...
block               :   {
                            st.levelUp();
                        }
                      const_decl var_decl procedure_list statement
                        {
                            $$ = new BlockNode();
                            $$->cons = $2;
                            $$->varCount = $3;
                            $$->next = $4;
                            $$->stmt = $5;

                            if (DEBUG_PARSER)
                                st.print();

                            st.levelDown();
                        }
                    ;

/* (COMPLETE) */
const_decl          : /*E*/
                        {
                            $$ = 0;
                        }
                    | T_CONST const_list T_SEMICOLON
                        {
                            $$ = $2;
                        }
                    ;

/* (COMPLETE) */
const_list          : T_IDENT T_EQ T_NUMBER
                        {
                            st.insert($1, ST_CONST);
                            $$ = new ConstNode($3, 0, $1);
                        }
                    | T_IDENT T_EQ T_NUMBER T_COMMA
                        {
                            st.insert($1, ST_CONST);
                        }
                        const_list
                        {
                            $$ = new ConstNode($3, $6, $1);
                        }
                    ;

/* (COMPLETE) */
var_decl            : /*E*/
                        {
                            $$ = 0;
                        }
                    | T_VAR var_list T_SEMICOLON
                        {
                            $$ = $2;
                        }
                    ;

/* (COMPLETE) */
var_list            : T_IDENT
                        {
                            st.insert($1, ST_VAR);
                            $$ = 1;
                        }
                    | T_IDENT T_COMMA 
                        {
                            st.insert($1, ST_VAR);
                        } 
                      var_list
                        {
                            $$ = $4 + 1;
                        }
                    ;

/* (COMPLETE) */
procedure_list      : /*E*/
                        {
                            $$ = 0;
                        }
                    | procedure T_SEMICOLON procedure_list
                        {
                            $$ = $1;
                            $$->next = $3;
                        }
                    ;

/* (COMPLETE) */
procedure           : T_PROCEDURE T_IDENT 
                        {
                            st.insert($2, ST_PROC);
                        }
                      T_SEMICOLON block
                        {
                            $$ = $5;
                            $$->name = $2;
                        }
                    ;

// NEED TO CHECK...
statement           : /*E*/
                        {
                            $$ = 0;
                        }
                    | T_IDENT T_ASSIGN expression
                        {
                            int level;
                            int offset;
                            int rc;

                            $$ = 0;

                            if ((rc = st.lookup($1, ST_VAR , level, offset)) == 0) {
                                $$ = new StmtNode();
                                $$->name = ":=";
                                $$->type = STMT_ASSIGN;
                                $$->stLevel = level;
                                $$->stOffset = offset;
                                $$->expr = $3;
                            } else {
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                            }
                        }
                    | T_CALL T_IDENT
                        {
                            int level;
                            int offset;
                            int rc;

                            $$ = 0;

                            if ((rc = st.lookup($2, ST_PROC , level, offset)) == 0) {
                                $$ = new StmtNode();
                                $$->name = "CALL";
                                $$->type = STMT_CALL;
                                $$->stLevel = level;
                                $$->stOffset = offset;
                                $$->procedure = $2;
                            } else {
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                            }
                        }
                    | T_BEGIN statement_list T_END
                        {
                            $$ = $2;
                        }
                    | T_IF condition T_THEN statement
                        {
                            $$ = new StmtNode();
                            $$->name = "IF";
                            $$->type = STMT_IF;
                            $$->jump = $4;
                        }
                    | T_WHILE condition T_DO statement
                        {
                            $$ = new StmtNode();
                            $$->name = "WHILE";
                            $$->type = STMT_WHILE;
                            $$->jump = $4;
                        }
                    | T_DEBUG
                        {
                            $$ = new StmtNode();
                            $$->name = "DEBUG";
                            $$->type = STMT_DEBUG;
                        }
                    | T_READ T_IDENT
                        {
                            int level;
                            int offset;
                            int rc;

                            $$ = 0;

                            if ((rc = st.lookup($2, ST_VAR , level, offset)) == 0) {
                                $$ = new StmtNode();
                                $$->name = "READ";
                                $$->type = STMT_READ;
                                $$->stLevel = level;
                                $$->stOffset = offset;
                            } else {
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                            }
                        }
                    | T_WRITE expression
                        {
                            $$ = new StmtNode();
                            $$->name = "WRITE";
                            $$->type = STMT_WRITE;
                            $$->expr = $2;
                        }
                    ;

// NEED TO CHECK...
statement_list      : statement
                        {
                            $$ = $1;
                        }
                    | statement T_SEMICOLON statement_list
                        {
                            // TODO SUCCESSOR
                            // TODO SUCCESSOR
                            // TODO SUCCESSOR
                            // TODO SUCCESSOR
                            // TODO SUCCESSOR
                            $$ = $1;                       
                        }
                    ;

/* (COMPLETE) */
condition           : T_ODD expression
                        {
                            $$ = new ExprNode();
                            $$->name = "ODD";
                            $$->type = EXPR_ODD;
                            $$->left = $2;
                        }
                    | expression T_EQ expression
                        {
                            $$ = new ExprNode();
                            $$->name = "=";
                            $$->type = EXPR_EQ;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    | expression T_HASH expression
                        {
                            $$ = new ExprNode();
                            $$->name = "#";
                            $$->type = EXPR_HASH;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    | expression T_LT expression
                        {
                            $$ = new ExprNode();
                            $$->name = "<";
                            $$->type = EXPR_LT;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    | expression T_LE expression
                        {
                            $$ = new ExprNode();
                            $$->name = "<=";
                            $$->type = EXPR_LE;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    | expression T_GT expression
                        {
                            $$ = new ExprNode();
                            $$->name = ">";
                            $$->type = EXPR_GT;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    | expression T_GE expression
                        {
                            $$ = new ExprNode();
                            $$->name = ">=";
                            $$->type = EXPR_GE;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    ;

/* (COMPLETE) */
expression          : term
                        {
                            $$ = $1;
                        }
                    | expression T_ADD term
                        {
                            $$ = new ExprNode();
                            $$->name = "+";
                            $$->type = EXPR_ADD;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    | expression T_SUB term
                        {
                            $$ = new ExprNode();
                            $$->name = "-";
                            $$->type = EXPR_SUB;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    ;

/* (COMPLETE) */
term                : factor
                        {
                            $$ = $1;
                        }
                    | term T_MUL factor
                        {
                            $$ = new ExprNode();
                            $$->name = "*";
                            $$->type = EXPR_MUL;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    | term T_DIV factor
                        {
                            $$ = new ExprNode();
                            $$->name = "/";
                            $$->type = EXPR_DIV;
                            $$->left = $1;
                            $$->right = $3;
                        }
                    ;

/* COMPLETE */
factor              : T_IDENT
                        {
                            int level;
                            int offset;
                            int rc;

                            $$ = 0;

                            if ((rc = st.lookup($1, ST_VAR | ST_CONST, level, offset)) == 0) {
                                $$ = new ExprNode();
                                $$->name = "IDENTIFIER";
                                $$->type = EXPR_IDENT;
                                $$->stLevel = level;
                                $$->stOffset = offset;
                            } else {
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                                // TODO ERROR MSG
                            }
                        }
                    | T_NUMBER
                        {
                            $$ = new ExprNode();
                            $$->name = "NUMBER";
                            $$->type = EXPR_NUM;
                            $$->value = $1;
                        }
                    | T_BRO expression T_BRC
                        {
                            $$ = $2;
                        }
                    | T_ADD factor
                        {
                            $$ = $2;
                        }
                    | T_SUB factor
                        {
                            $$ = new ExprNode();
                            $$->name = "ChangeSign";
                            $$->type = EXPR_CHS;
                            $$->left = $2;
                        }
                    ;
%%

int yyerror(const char* s) {
    fprintf(stderr, "Error in line %d: %s (before token '%s')\n", line, s, yytext);
    return -1;
}
