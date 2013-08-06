#include <cstdio>
#include "ast.hpp"

extern FILE *yyin;
extern int yyparse();

// TESTING...
extern BlockNode *rootNode;

int main (int argc, char** argv) {
    yyin = fopen(argv[1], "r");

    int rc = yyparse();

    // TESTING
    BlockNode *node = rootNode;

    while (node != 0) {
        cout << "BlockNode: " << node->name << endl;
        cout << "\tVar Count: " << node->varCount << endl;

        ConstNode *cons = node->cons;

        cout << "\tConstants:" << endl;

        while (cons != 0) {
            cout << "\t\tConstNode: " << cons->name << endl;
            cout << "\t\tValue: " << cons->value << endl;

            if (cons->next != 0)
                cout << "\t\tNext: " << cons->next->name << endl;

            cout << endl;

            cons = cons->next;
        }

        node = node->next;
    }

    return rc;
}