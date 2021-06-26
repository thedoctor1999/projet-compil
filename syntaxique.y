%{
#include<stdio.h>
#include "ts.h"

int yylex();
int yyerror(char *s);

typedef struct variable{
    char* nom;
    int ival;
    float fval;
    int type;
}variable;

%}

%union {
    char* chaine;
    int entier;
}

%token <entier>NUMB <chaine>IDENTIFIANT <chaine>TYPE
%token PLUS MINUS TIMES DIVIDE ABSOL PO PF AFFECTER PV VIRG
%token NEWLINE

%type <entier>expAritmetique
%type <entier>factor
%type <entier>term

%%
instructions:
            |instructions NEWLINE
            |instructions instruction NEWLINE
;
instruction: daclaration
            | affectation
            | expAritmetique
;
daclaration: TYPE listeidf PV
;
listeidf: IDENTIFIANT
        | listeidf VIRG IDENTIFIANT
;
affectation: IDENTIFIANT AFFECTER expAritmetique PV
;

expAritmetique: factor
    | expAritmetique PLUS factor   {$$ = $1 + $3;}
    | expAritmetique MINUS factor  {$$ = $1 - $3;}
    ;

factor: term
    | factor TIMES term     {$$ = $1 * $3;}
    | factor DIVIDE term    {$$ = $1 / $3;}
    ;

term: NUMB
    | PO expAritmetique PF                {$$ = $2;}
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