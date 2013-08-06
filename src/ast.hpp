#ifndef AST_HPP_
#define AST_HPP_

#define DEBUG_AST false

#include <string>
#include <iostream>

using std::string;
using std::cout;
using std::endl;

class ConstNode {

public:
    ConstNode(int value, ConstNode *next, string name);
    void debug();

    string name;
    int value;
    ConstNode *next;
};

enum exprType {
    EXPR_ODD, EXPR_EQ, EXPR_HASH, EXPR_LT,
    EXPR_LE, EXPR_GT, EXPR_GE, EXPR_ADD,
    EXPR_SUB, EXPR_MUL, EXPR_DIV, EXPR_NUM,
    EXPR_VAR, EXPR_CHS, EXPR_IDENT
};

class ExprNode {

public:
    ExprNode();
    void debug();

    string name;
    int type;
    int value;
    int stLevel;
    int stOffset;
    ExprNode *left;
    ExprNode *right;
};

enum stmtType {
    STMT_ASSIGN, STMT_WRITE, STMT_READ, STMT_WHILE,
    STMT_IF, STMT_CALL, STMT_DEBUG
};

class StmtNode {

public:
    StmtNode();
    void debug();

    string name;
    string procedure;
    int type;
    int stLevel;
    int stOffset;
    ExprNode *expr;
    StmtNode *jump;
    StmtNode *next;
};

class BlockNode {

public:
	BlockNode();
    void debug();

    string name;
    int varCount;
	ConstNode *cons;
    BlockNode *sub;
    BlockNode *next;
    StmtNode *stmt;
};

#endif /* AST_HPP_ */
