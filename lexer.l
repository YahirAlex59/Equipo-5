%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"

int num_linea = 1;
%}

%option noyywrap

%%

    /* 1. COMENTARIOS */
"//"[^\n]*              { fprintf(yyout, "COMENTARIO "); }

    /* 2. PALABRAS RESERVADAS */
"Ent"                   { fprintf(yyout, "TIPO ");     yylval.str = strdup(yytext); return TIPO; }
"Npd"                   { fprintf(yyout, "TIPO ");     yylval.str = strdup(yytext); return TIPO; }
"let"                   { fprintf(yyout, "TIPO ");     yylval.str = strdup(yytext); return TIPO; }
"logic"                 { fprintf(yyout, "TIPO ");     yylval.str = strdup(yytext); return TIPO; }
"txt"                   { fprintf(yyout, "TIPO ");     yylval.str = strdup(yytext); return TIPO; }

"imp"                   { fprintf(yyout, "MOSTRAR ");  return MOSTRAR; }
"defin"                 { fprintf(yyout, "DEFINE ");   return DEFINE; }

"true"                  { fprintf(yyout, "BOOLEANO "); yylval.str = strdup(yytext); return BOOLEANO; }
"false"                 { fprintf(yyout, "BOOLEANO "); yylval.str = strdup(yytext); return BOOLEANO; }
