%{
#include <stdlib.h>
extern void yyerror(const char *str);

#include "number.h"
#include "y.tab.h"

int COMMENT = 0;
%}

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

[\-\+\(\)\=\/\*\^] { return *yytext; }

     
[+-]?([1-9][0-9]+|[0-9])\.?[0-9]+|(\.[0-9]+)    {
                                                    if(!COMMENT) {
                                                        yylval.num = NEW_RATIONAL(strtod(yytext, NULL));
                                                        return RATIONAL;
                                                    } 
                                                }

[+-]?([1-9][0-9]|[0-9])    {
                                if(!COMMENT) {    
                                    yylval.num = NEW_INTEGER(strtol(yytext, NULL, 10));;
                                    return INTEGER;
                                } 
                            }

{identifier} {ECHO; if(!COMMENT) printf("\nIDENTIFIER\n");}

\{ {ECHO; if(!COMMENT) printf("\nBLOCK BEGINS\n");}
\} {ECHO; if(!COMMENT) printf("\nBLOCK ENDS\n");}

;                       {ECHO; printf("\nSEMICOLON\n");}
[ \t]+                  /* ignore whitespace */;		


%%

int yywrap(void)		
{
    return 1;
}