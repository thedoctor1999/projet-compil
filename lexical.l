%option yylineno
%{
#include "syntaxique.tab.h"

/* TABLE DES SYMBOLS */
typedef struct ref {
    struct ref *next;
    int lineno;
}ref;

typedef struct symbol{
    char *name;
    struct ref *reflist;
}symbol;

/*enum yytokentype {
        NUMB = 258,
        PLUS = 259,
        MINUS = 260,
        TIMES = 261,
        DIVIDE = 262,
        ABSOL = 263,
        NEWLINE = 264,
        PO = 265,
        PF = 266,
        IDENTIFIANT = 267
};*/

/* simple symtab of fixed size */
#define NHASH 1000
struct symbol symtab[NHASH];

struct symbol *chercher(char* sym);
void addref(int lineno, char* word);

void afficherTS();

/* hash a symbol */
static unsigned symhash(char *sym){
    unsigned int hash = 0;
    unsigned c;

    while(c = *sym++)   hash = hash*9 ^ c;

    return hash;
}

struct symbol *chercher(char* sym){
    struct symbol *sp = &symtab[symhash(sym)%NHASH];
    int scount = NHASH;

    while(--scount >= 0){
        if(sp->name && !strcmp(sp->name, sym))  return sp;

        if(!sp->name){
            sp->name = strdup(sym);
            sp->reflist = 0;
            return sp;
        }

        if(++sp >= symtab+NHASH)    sp = symtab;
    }
    fputs("symbol table overflow\n", stderr);
    abort();    /* tried them all, table is full */
}

void addref(int lineno, char* word){
    struct ref *r;
    struct symbol *sp = chercher(word);

    if( sp->reflist && sp->reflist->lineno == lineno)  return;

    r = malloc(sizeof(ref));
    if(!r){
        fputs("out of space\n", stderr);
        abort();
    }

    r->next = sp->reflist;
    r->lineno = lineno;
    sp->reflist = r;
}

void afficherTS(){
    ref *r;
    for(int i=0; i<NHASH; i++){
        if(symtab[i].name){
            printf("%s refferences :", symtab[i].name);
            r = symtab[i].reflist;
            do{
                printf(" %d,", r->lineno);
            }while(r=r->next);
            printf("\n");
        }
    }
}

%}
%%
[a-zA-Z]+   {addref(yylineno, yytext);  return IDENTIFIANT;}
"+"     {   return PLUS;}
"-"     {   return MINUS;}
"*"     {   return TIMES;}
"/"     {   return DIVIDE;}
"|"     {   return ABSOL;}
"("     {   return PO;}
")"     {   return PF;}
[0-9]+    {   yylval = atoi(yytext);  return NUMB;}
\n      {   return NEWLINE;}
[ \t]   {   }
"//".*(\n)?  { return NEWLINE;}
.       {   printf("Mystery character %c\n", *yytext);}

%%
/*int main(int argc, char** argv){
    yylex();

    ref *r;
    for(int i=0; i<NHASH; i++){
        if(symtab[i].name){
            printf("%s\nrefferences :", symtab[i].name);
            r = symtab[i].reflist;
            do{
                printf(" %d", r->lineno);
            }while(r=r->next);
        }
    }
    return 0;
}*/