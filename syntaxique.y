%{
#include<stdio.h>
#include "ts.h"

int yylex();
int yyerror(char *s);
%}

%token NUMB IDENTIFIANT
%token PLUS MINUS TIMES DIVIDE ABSOL PO PF
%token NEWLINE

%%
calclist:
        | calclist IDENTIFIANT NEWLINE
        | calclist NEWLINE
        | calclist exp NEWLINE  {printf("= %d\n", $2);}
        ;

exp: factor
    | exp PLUS factor   {$$ = $1 + $3;}
    | exp MINUS factor  {$$ = $1 - $3;}
    ;

factor: term
    | factor TIMES term     {$$ = $1 * $3;}
    | factor DIVIDE term    {$$ = $1 / $3;}
    ;

term: NUMB
    | PO exp PF                {$$ = $2;}
    | ABSOL term ABSOL          {$$ = $2 >= 0 ? $2 : -$2;}
    ;
%%


int main(int argc, char **argv){
    yyparse();
    afficherTS();
}

int yyerror(char *s){
    fprintf(stderr, "error: %s\n", s);
}