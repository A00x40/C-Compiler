%{
#include <stdio.h>
#include <string.h>

#include "number.h"

extern FILE *yyin;
extern int yylex(void);

void yyerror(const char *str);
extern char* yytext;
%}

%union {
    struct number num;
}

%start program

%token <num> INTEGER
%token <num> RATIONAL
%token IDENTIFIER CONST 
%token RELOP AND OR IF THEN ELSE ENDIF BOOLTRUE BOOLFALSE

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
    ;

//
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

//
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