#include <cstdio>

extern FILE *yyin;
extern int yyparse();

int main (int argc, char** argv) {
    yyin = fopen(argv[1], "r");

    int rc = yyparse();

    return rc;
}