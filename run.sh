yacc -d bas.y
lex bas.l

cc number.c lex.yy.c y.tab.c -ly -ll -lm -obas.exe