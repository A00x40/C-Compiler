bison -b y -d bas.y
flex bas.l
gcc lex.yy.c y.tab.c
./a.exe default_test.txt
