#include "ast.hpp"

ConstNode::ConstNode(int value, ConstNode *next, string name) {
    this->value = value;
    this->next = next;
    this->name = name;

    debug();
}

void ConstNode::debug() {
    if (DEBUG_AST) {
        cout << "Debug: ConstNode.ConstNode()" << endl;
        cout << "       Name: " << name << endl;
        cout << "       Value: " << value << endl;

        if (next != 0)
            cout << "       Next: " << next->name << endl;
    }
}

// TODO CONSTRUCTOR
ExprNode::ExprNode() {
    this->name = "";
    this->type = 0;
    this->value = 0;
    this->stLevel = 0;
    this->stOffset = 0;
    this->left = 0;
    this->right = 0;

    debug();
}

void ExprNode::debug() {
    if (DEBUG_AST) {
        cout << "Debug: ExprNode.ExprNode()" << endl;
        cout << "       New expression created" << endl;
    }
}

// TODO CONSTRUCTOR
StmtNode::StmtNode() {
    this->name = "";
    this->procedure = "";
    this->type = 0;
    this->stLevel = 0;
    this->stOffset = 0;
    this->expr = 0;
    this->jump = 0;
    this->next = 0;

    debug();
}

void StmtNode::debug() {
    if (DEBUG_AST) {
        cout << "Debug: StmtNode.StmtNode()" << endl;
        cout << "       New statement created" << endl;
    }
}

// TODO CONSTRUCTOR
BlockNode::BlockNode() {
    this->name = "";
    this->varCount = 0;
    this->cons = 0;
    this->sub = 0;
    this->next = 0;
    this->stmt = 0;

    debug();
}

void BlockNode::debug() {
    if (DEBUG_AST) {
        cout << "Debug: BlockNode.BlockNode()" << endl;
        cout << "       New block created" << endl;
        cout << "       Name: " << name << endl;
    }
}
