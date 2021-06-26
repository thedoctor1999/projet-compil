#include<string.h>
#include<stdio.h>
#include<stdlib.h>

/* TABLE DES SYMBOLS */
typedef struct ref {
    struct ref *next;
    int lineno;
}ref;

typedef struct symbol{
    int state;
    char *name;
    char nature;
    char *type;
    char *valeur;
    struct ref *reflist;
}symbol;


/* simple symtab of fixed size */
#define NHASH 1000
struct symbol symtab[NHASH];


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
    abort();    //table is full
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

void setValue(char* symbol, char* valeur){
    struct symbol *sp = chercher(symbol);
    sp->valeur = strdup(valeur);
}

void setType(char* symbol, char* type){
    struct symbol *sp = chercher(symbol);
    sp->type = strdup(type);
}


void afficherTS(){
    ref *r;

    printf("\n\t\tTable des Symbols\t\t\n\n|");
    printf("state\t\t|");
    printf("Name\t\t|");
    printf("nature\t\t|");
    printf("Type\t\t|");
    printf("valeur\t\t|");
    printf("References\t\t\n");
    for(int i=0; i<100; i++)
        printf("-");
    printf("\n");

    for(int i=0; i<NHASH; i++){
        if(symtab[i].name){
            printf("|%d\t\t|", symtab[i].state);
            printf("%s\t\t|", symtab[i].name);
            printf("%d\t\t|", symtab[i].nature);
            printf("%s\t\t|", symtab[i].type);
            printf("%s\t\t|", symtab[i].valeur);

            r = symtab[i].reflist;
            do{
                printf(" %d,", r->lineno);
            }while(r=r->next);
            printf("\t\t\n");
        }
    }
}
