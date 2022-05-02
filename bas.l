%{
#include <stdio.h>

int COMMENT = 0;
%}

digit [0-9]
number [0-9]+
identifier [a-zA-Z_][a-zA-Z0-9_]*

/*Rule Section*/
%%

const {ECHO; printf("\nKEYWORD\n");}
int {ECHO; printf("\nKEYWORD\n");}
float {ECHO; printf("\nKEYWORD\n");}
char {ECHO; printf("\nKEYWORD\n");}

if {ECHO; printf("\nKEYWORD\n");}
else {ECHO; printf("\nKEYWORD\n");}	

do {ECHO; printf("\nKEYWORD\n");}
while {ECHO; printf("\nKEYWORD\n");}
for	{ECHO; printf("\nKEYWORD\n");}

return {ECHO; printf("\nKEYWORD\n");}
break {ECHO; printf("\nKEYWORD\n");}
continue {ECHO; printf("\nKEYWORD\n");}

switch {ECHO; printf("\nKEYWORD\n");}
case {ECHO; printf("\nKEYWORD\n");}

"/*" {COMMENT=1;}
"*/" {COMMENT=0;}

[+-]?{number} {ECHO; if(!COMMENT) printf("\nINTEGER\n");}
[+-]?((({number}\.{digit}*|\.{number})([eE][+-]?{number})?)|({number}[eE][+-]?{number})) {ECHO; if(!COMMENT) printf("\nFloat\n");}  

{identifier} {ECHO; if(!COMMENT) printf("\nIDENTIFIER\n");}

\{ {ECHO; if(!COMMENT) printf("\nBLOCK BEGINS\n");}
\} {ECHO; if(!COMMENT) printf("\nBLOCK ENDS\n");}

;                       {ECHO; printf("\nSEMICOLON\n");}
\n                      /* ignore EOL */;
[ \t]+                  /* ignore whitespace */;		
%%

/*call the yywrap function*/
int yywrap()		
{return 1;}


/*Auxiliary function*/
/*Driver function*/

int main(void)
{
/*call the yylex function.*/
yylex();
return 0;
}
