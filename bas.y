%{
#include <stdio.h>
#include <string.h>

#include "number.h"

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

%right '='
%left '+' '-'
%left '*' '/'
%left '(' ')'
%right '^'

%type<num> expr

%%

program:
    program statements '\n'
    |
	;

statements:
    statements expr
    |
    ;

expr:
    INTEGER { PRINT_NUMBER($1); $$ = $1; }
    |  RATIONAL { PRINT_NUMBER($1); $$ = $1; }
    |  expr '+' expr { printf("ADD result"); PRINT_NUMBER($$); $$ = ADD($1, $3); }
    |  expr '-' expr { printf("SUB result"); PRINT_NUMBER($$); $$ = SUBTRACT($1, $3); }
    |  expr '*' expr { printf("MULT result"); PRINT_NUMBER($$); $$ = MULTIPLY($1, $3); }
    |  expr '/' expr { printf("DIV result"); PRINT_NUMBER($$); $$ = DIVIDE($1, $3); }
    |  expr '^' expr { printf("POW result"); PRINT_NUMBER($$); $$ = POW($1, $3); }
    |  '(' expr ')'  { printf("BRACKETS result"); $$ = $2; }
    ;
%%


void yyerror(const char *str)
{
	fprintf(stderr,"error: %s\n",str);
}

int main()
{
	yyparse();
    return 0;
}