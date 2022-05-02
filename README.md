# C-Compiler Project

A project to design a programming language using lex and yacc

## Required Libraries installation

* sudo apt-get install flex
* sudo apt-get install bison

## Introduction

First, we need to specify all pattern matching rules for lex (bas.l) and grammar rules for yacc (bas.y)

Commands to create our compiler, bas.exe:

* yacc -d bas.y
* lex bas.l
* cc lex.yy.c y.tab.c -obase.exe
