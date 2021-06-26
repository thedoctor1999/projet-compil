%option yylineno
%{
#include "syntaxique.tab.h"
//#include "ts.h"
%}
%%
"REAL"   {yylval.chaine=yytext;   printf(" TYPE "); return TYPE;}
[a-zA-Z]+   {yylval.chaine=yytext;   addref(yylineno, yytext);  printf(" IDENTIFIANT "); return IDENTIFIANT;}
"+"     {   return PLUS;}
"-"     {   return MINUS;}
"*"     {   return TIMES;}
"/"     {   return DIVIDE;}
"|"     {   return ABSOL;}
"("     {   return PO;}
")"     {   return PF;}
";"     {   return PV;}
","     {   return VIRG;}
":="    {   return AFFECTER;}
[0-9]+    {   yylval.entier = atoi(yytext);  return NUMB;}
\n      { printf(" NEWLINE \n");  return NEWLINE;}
[ \t]   {   }
"//".*  { return NEWLINE;}
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