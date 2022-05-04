%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "number.h"

extern FILE *yyin;
extern int yylex(void);

void yyerror(const char *str);

extern char* yytext;

bool exitSwitch = false;      /* true if the switch variable matches a case number, so after the assignment we can exit the switch */
bool skipAssignment = true;   /* true if the case assignment has to be skipped */
%}

%union {
    struct number num;
}

%start program

%token <num> INTEGER
%token <num> RATIONAL
%token IDENTIFIER CONST 
%token RELOP AND OR BOOLTRUE BOOLFALSE
%token IF THEN ELSE ENDIF
%token DO WHILE ENDWHILE ENDDO
%token FOR ENDFOR
%token SWITCH CASE ENDSWITCH DEFAULT BREAK

%right '='
%left '+' '-'
%left '*' '/'
%left '(' ')'
%right '^'

%left AND
%left OR

%type<num> expr

%%

program:
    program statements 
    |
	;

statements:
    expr_stmt 
    | if_stmt { printf("IF statement\n"); }
    | while_stmt { printf("WHILE statement\n"); }
    | do_stmt { printf("DO WHILE statement\n"); }
    | for_loop { printf("FOR LOOP\n"); }
    | switch_stmt { printf("SWITCH statement\n"); }
    ;

expr_stmt:
    IDENTIFIER '=' expr ';' { printf("Variable Assignemnt statement\n"); }
    | CONST IDENTIFIER '=' expr ';' { printf("Constant Assignemnt statement\n"); }
    ;

expr:
    INTEGER { $$ = $1; }
    |  RATIONAL { $$ = $1; }
    |  expr '+' expr { $$ = ADD($1, $3); }
    |  expr '-' expr { $$ = SUBTRACT($1, $3); }
    |  expr '*' expr { $$ = MULTIPLY($1, $3); }
    |  expr '/' expr { $$ = DIVIDE($1, $3); }
    |  expr '^' expr { $$ = POW($1, $3); }
    |  '(' expr ')'  { $$ = $2; }
    ;

condition_stmt: 
    IDENTIFIER RELOP IDENTIFIER 
    | IDENTIFIER RELOP INTEGER 
    | IDENTIFIER RELOP RATIONAL 
    | INTEGER RELOP IDENTIFIER 
    | RATIONAL RELOP IDENTIFIER 
    | condition_stmt AND condition_stmt 
    | condition_stmt OR condition_stmt 
    | BOOLTRUE 
    | BOOLFALSE
    ;

if_stmt: 
    IF condition_stmt THEN statements ELSE statements ENDIF 
    | IF condition_stmt THEN statements ENDIF
    ;

while_stmt: 
    WHILE condition_stmt THEN statements ENDWHILE
    ;

do_stmt: 
    DO statements WHILE condition_stmt ENDDO
    ;

for_loop: 
    FOR '(' expr ';' condition_stmt ';' expr ')' DO statements ENDFOR
    ;

switch_stmt: 
    SWITCH '(' IDENTIFIER ')' DO  
    cases
    ENDSWITCH
    ;

cases : 
    case cases
    | DEFAULT
    ;

case :
    CASE IDENTIFIER
    {   
        /* check if the switch variable value is equal to the case number */
        
        /* if the case num matches the switch variable we do the assignment */
        /*if
            skipAssignment = false; 
            exitSwitch = true;
        
        else skipAssignment = true;*/
    }
    ':' statements BREAK    
    {   
        /* if case match, we exit the switch and assign the value to z */
        /*if( exitSwitch ) 
        {
            exit(0);
        }*/
    }

%%


void yyerror(const char *str)
{
	fprintf(stderr,"error: %s\n",str);
}

int main()
{
	FILE * pt = fopen("tests/test1.txt", "r" );
    if(!pt)
    {
        printf("Non existant file");
        return -1;
    }
    yyin = pt;
    do
    {
        yyparse();
    }   while (!feof(yyin));
    return 0;
}