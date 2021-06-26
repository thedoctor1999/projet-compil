%option yylineno
%{
#include "syntaxique.tab.h"
//#include "ts.h"
%}
%%
"INTEGER"   {yylval.chaine="INTEGER";   printf(" TYPE "); return TYPE;}
"REAL"   {yylval.chaine="REAL";   printf(" TYPE "); return TYPE;}
"CHAR"   {yylval.chaine="CHAR";   printf(" TYPE "); return TYPE;}
"STRING"   {yylval.chaine="STRING";   printf(" TYPE "); return TYPE;}
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
":="    {   printf(" AFFECTER ");   return AFFECTER;}
[0-9]+    {   yylval.entier = atoi(yytext);  return NUMB;}
\n      { printf(" NEWLINE \n");  return NEWLINE;}
[ \t]   {   }
"//".*  { return NEWLINE;}
.       {   printf("Mystery character %c\n", *yytext);}

%%

