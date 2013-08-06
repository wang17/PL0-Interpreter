#ifndef SYMBOLTABLE_HPP_ 
#define SYMBOLTABLE_HPP_

#include <map>
#include <string>
#include <iostream>

#define DEBUG_SYMBOLTABLE false

using std::map;
using std::string;
using std::cout;
using std::endl;

enum symbolType { ST_CONST, ST_VAR, ST_PROC };

class SymbolTableEntry {
    friend class SymbolTable;
public:
    SymbolTableEntry(int type = ST_CONST, int offset = 0);

private:
    int type;
    int offset;
};

class SymbolTable {
public:
    SymbolTable();

    void levelUp();
    void levelDown();
    int insert(string name, int type);
    int lookup(string name, int type, int &level, int &offset);
    void print();

private:
    map<int, map<string, SymbolTableEntry> > content;
    int level;
};

#endif /* SYMBOLTABLE_HPP_ */
