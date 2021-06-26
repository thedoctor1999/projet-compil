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
        | calclist expAritmetque NEWLINE  {printf("= %d\n", $2);}
        ;

expAritmetque: factor
    | expAritmetque PLUS factor   {$$ = $1 + $3;}
    | expAritmetque MINUS factor  {$$ = $1 - $3;}
    ;

factor: term
    | factor TIMES term     {$$ = $1 * $3;}
    | factor DIVIDE term    {$$ = $1 / $3;}
    ;

term: NUMB
    | PO expAritmetque PF                {$$ = $2;}
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