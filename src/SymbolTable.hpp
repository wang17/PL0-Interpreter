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

enum symbolType { CONST, VAR, PROC };

class SymbolTableEntry {
    friend class SymbolTable;
public:
    SymbolTableEntry(symbolType type = CONST, int offset = 0);

private:
    symbolType type;
    int offset;
};

class SymbolTable {
public:
    SymbolTable();

    void levelUp();
    void levelDown();
    int insert(string name, symbolType type);
    int lookup(string name, symbolType type, int &level, int &offset);
    void print();

private:
    map<int, map<string, SymbolTableEntry> > content;
    int level;
};

#endif /* PL0_SYMBOLTABLE_HPP_ */
