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

typedef struct liste_de_chaines{
    char *chaine;
    struct liste_de_chaines *suivant;
}liste_de_chaines;


struct liste_de_chaines* liste_ident;
%}

%union {
    struct liste_de_chaines* tableau;
    char* chaine;
    int entier;
}

%token <entier>NUMB <chaine>IDENTIFIANT <chaine>TYPE
%token PLUS MINUS TIMES DIVIDE ABSOL PO PF AFFECTER PV VIRG
%token NEWLINE

%type <entier>expAritmetique
%type <entier>factor
%type <entier>term
%type <tableau>listeidf

%%
instructions:
            |instructions NEWLINE
            |instructions instruction NEWLINE
;
instruction: daclaration
            | affectation
            | expAritmetique    {   printf("=%d\n", $1);}
;
daclaration: TYPE listeidf PV                           {
                                                        struct liste_de_chaines *s = liste_ident;
                                                         //for(s=liste_ident; s->suivant!=NULL; s=s->suivant){
                                                            setType(s->chaine, $1);
                                                            $2 = NULL;
                                                        //}
                                                        }
;
listeidf: IDENTIFIANT                                   {struct liste_de_chaines *nouveau = malloc(sizeof(struct liste_de_chaines));
                                                         nouveau->chaine = strdup($1);
                                                         nouveau->suivant = $$->suivant;
                                                         $$->suivant = nouveau;
                                                         liste_ident = $$->suivant;}
        | listeidf VIRG IDENTIFIANT                     {
                                                         struct liste_de_chaines *nouveau = malloc(sizeof(struct liste_de_chaines));
                                                         nouveau->chaine = strdup($3);
                                                         nouveau->suivant = $$->suivant;
                                                         $$->suivant = nouveau;
                                                         liste_ident = $$->suivant;}
;
affectation: IDENTIFIANT AFFECTER expAritmetique PV     {char* s = malloc(20*sizeof(char));   sprintf(s, "%d", $3); printf("\n%s %s %s %s\n", $1, $2, $3, $4);   setValue($1, s);}
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