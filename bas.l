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

"/*" { COMMENT=1; } 
"*/" { if(COMMENT) COMMENT=0; else yyerror("No opening for closed comment"); }

const { if(!COMMENT) return CONST; }

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

\"[^\"]*\"|\"\" { if(!COMMENT) return STRING; }

[\-\+\(\)\=\/\*\^\;\,\:] { if(!COMMENT) return *yytext; }

\&\& { if(!COMMENT) return AND; }
\|\| { if(!COMMENT) return OR; } 
\>|\<|\>\=|\<\=|\!\=|\=\= { return RELOP; }

TRUE { if(!COMMENT) return BOOLTRUE; }
FALSE { if(!COMMENT) return BOOLFALSE; }

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
break\n   { if(!COMMENT) return BREAK; }
default { if(!COMMENT) return DEFAULT; }
end" "switch\n  { if(!COMMENT) return ENDSWITCH; }

print { if(!COMMENT) return PRINT; }

return" "0\; { if(!COMMENT) return END; }


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