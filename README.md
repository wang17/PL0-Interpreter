PL0-Interpreter
===============
PL/0 ist eine vereinfachte Programmiersprache. Sie dient als Muster, um im Buch
Compilerbau von Niklaus Wirth zu zeigen, wie man einen Compiler herstellt. Die
Sprache kann nur mit Zahlenwerten umgehen und ist nicht dazu gedacht, wirklich
eingesetzt zu werden.

Die Syntaxregeln der Modellsprache in EBNF:

```
program    = block "." .

block      = [ "CONST" ident "=" number { "," ident "=" number } ";" ]
             [ "VAR" ident { "," ident } ";" ]
             { "PROCEDURE" ident ";" block ";" } statement .

statement  = [ ident ":=" expression | "CALL" ident | "?" ident | "!" expression |
               "BEGIN" statement { ";" statement } "END" |
               "IF" condition "THEN" statement |
               "WHILE" condition "DO" statement ] .

condition  = "ODD" expression | expression ( "=" | "#" | "<" | "<=" | ">" | ">=" ) expression .

expression = [ "+" | "-" ] term { ( "+" | "-" ) term } .

term       = factor { ( "*" | "/" ) factor } .

factor     = ident | number | "(" expression ")" .
```
http://de.wikipedia.org/wiki/PL/0
