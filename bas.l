%{
#include <stdlib.h>
extern void yyerror(const char *str);

#include "number.h"
#include "y.tab.h"

int COMMENT = 0;
int scope = 0;
int nline = 0;
%}

identifier _[a-zA-Z][a-zA-Z0-9]*

/*Rule Section*/
%%

decl { return DECL; }
def { return DEFINE; }
return { return RET; }
end" "decl\n { return ENDDECL; }

main { return MAIN; }

"/*" {COMMENT=1;}
"*/" {COMMENT=0;}

const { return CONST; }

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

{identifier}    {
                    if(!COMMENT)  {
                        
                        //yylval = *yytext - 'a';
                        return IDENTIFIER;
                    }
                }

\"[^\"]*\"|\"\" { return STRING; }

[\-\+\(\)\=\/\*\^\;\,\:] { return *yytext; }

\&\& { return AND; }
\|\| { return OR; } 
\>|\<|\>\=|\<\=|\!\=|\=\= { return RELOP; }

TRUE { return BOOLTRUE; }
FALSE { return BOOLFALSE; }

if  { if(!COMMENT) return IF; }
end" "if\n  { if(!COMMENT) return ENDIF; }
then\n  { if(!COMMENT) return THEN; }
else\n  { if(!COMMENT) return ELSE; }

while  { if(!COMMENT) return WHILE; }
end" "while\n  { if(!COMMENT) return ENDWHILE; }
do\n  { if(!COMMENT) return DO; }
end" "do\n  { if(!COMMENT) return ENDDO; }

for  { if(!COMMENT) return FOR; }
end" "for\n  { if(!COMMENT) return ENDFOR; }

switch  { if(!COMMENT) return SWITCH; }
case  { if(!COMMENT) return CASE; }
break\n   { return BREAK; }
default { return DEFAULT; }
end" "switch\n  { return ENDSWITCH; }

print { return PRINT; }

return" "0\; { return END; }


\{  { 
        if(!COMMENT) {
            scope++; 
            return *yytext; 
        }
    }

\}  { 
        if(!COMMENT) {
            scope--; 
            return *yytext; 
        }
    }

\n { nline++; }
[ \t] 		
 
%%

int yywrap(void)		
{
    return 1;
}