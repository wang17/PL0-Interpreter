#include "symbolTable.hpp"

SymbolTableEntry::SymbolTableEntry(int type, int offset) {
    this->type = type;
    this->offset = offset;
}

SymbolTable::SymbolTable() {
    level = -1;
}

void SymbolTable::levelUp() {
    content[++level];

    if (DEBUG_SYMBOLTABLE) {
        cout << "Debug: SymbolTable.levelUp()" << endl;
        cout << "       Level is now: " << level << endl;
    }
}

void SymbolTable::levelDown() {
    content[level--].clear();

    if (DEBUG_SYMBOLTABLE) {
        cout << "Debug: SymbolTable.levelDown()" << endl;
        cout << "       Level is now: " << level << endl;
    }
}

int SymbolTable::insert(string name, int type) {
    int offset = content[level].size();

    if (content[level].find(name) != content[level].end())
        return -1;  // Key exists

    content[level][name] = SymbolTableEntry(type, offset);

    if (DEBUG_SYMBOLTABLE) {
        cout << "Debug: SymbolTable.insert()" << endl;
        cout << "       Name: " << name << ", Offset: " << offset << 
                        ", Type: " << type << endl;
    }

    return 0;
}

int SymbolTable::lookup(string name, int type, int &level, int &offset) {
    map<int, map<string, SymbolTableEntry> >::iterator mlevel;

    for (mlevel = content.begin(); mlevel != content.end(); mlevel++) {
        if (mlevel->second.find(name) != mlevel->second.end()) {
            if (mlevel->second[name].type != type) {

                if (DEBUG_SYMBOLTABLE) {
                    cout << "Debug: SymbolTable.lookup()" << endl;
                    cout << "       Found: " << name << ", but wrong type." << endl;
                    cout << "       Expected Type: " << type << 
                                    ", Result: " << mlevel->second[name].type << endl;
                }

                return -1;  // Wrong type
            }

            level = mlevel->first;
            offset = mlevel->second[name].offset;

            if (DEBUG_SYMBOLTABLE) {
                cout << "Debug: SymbolTable.lookup()" << endl;
                cout << "       Found: " << name << ", Level: " << level << 
                                ", Type: " << type << " Offset: " << offset << endl;
            }

            return 0;   // found
        }
    }

    if (DEBUG_SYMBOLTABLE) {
        cout << "Debug: SymbolTable.lookup()" << endl;
        cout << "       Not found: " << name << ", Type: " << type << endl;
    }

    return -2;  // Not found
}

void SymbolTable::print() {
    map<int, map<string, SymbolTableEntry> >::iterator level;
    map<string, SymbolTableEntry>::iterator pos;

    if (DEBUG_SYMBOLTABLE)
        cout << "Debug: SymbolTable.print():" << endl;

    for (level = content.begin(); level != content.end(); level++) {
        cout << "       Level: " << level->first << " Height: " << level->second.size() << endl;

        for (pos = level->second.begin(); pos != level->second.end(); pos++) {
            cout << "              Key: " << pos->first << endl;
            cout << "                   Offset: " << pos->second.offset << 
                                        " Type: " << pos->second.type << endl;
        }
    }
}
