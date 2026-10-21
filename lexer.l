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

    /* 3. LITERALES */
[0-9]+"."[0-9]+         { fprintf(yyout, "DECIMAL ");  yylval.str = strdup(yytext); return DECIMAL; }
[0-9]+                  { fprintf(yyout, "ENTERO ");   yylval.str = strdup(yytext); return ENTERO; }
'.'                     { fprintf(yyout, "CARACTER "); yylval.str = strdup(yytext); return CARACTER; }
\"[^\"]*\"              { fprintf(yyout, "CADENA ");   yylval.str = strdup(yytext); return CADENA; }

    /* 4. VARIABLES */
[a-zA-Z_][a-zA-Z0-9_]*  { fprintf(yyout, "VARIABLE "); yylval.str = strdup(yytext); return VARIABLE; }

    /* 5. OPERADORES Y SIMBOLOS */
"+"                     { fprintf(yyout, "SUMA ");       return SUMA; }
"-"                     { fprintf(yyout, "RESTA ");      return RESTA; }
"*"                     { fprintf(yyout, "MULT ");       return MULT; }
"/"                     { fprintf(yyout, "DIV ");        return DIV; }
"=="                    { fprintf(yyout, "IGUAL ");      return IGUAL; }
"="                     { fprintf(yyout, "ASIGNACION "); return ASIGNACION; }
"<"                     { fprintf(yyout, "MENOR ");      return MENOR; }
">"                     { fprintf(yyout, "MAYOR ");      return MAYOR; }
";"                     { fprintf(yyout, "PUNTOYCOMA "); return PUNTOYCOMA; }

    /* 6. ESPACIOS Y SALTOS DE LINEA */
[ \t]+                  { }
\r?\n                   { fprintf(yyout, "\n"); num_linea++; }

    /* 7. ERRORES LEXICOS */
.                       { printf("Error lexico en linea %d: '%s' no se reconoce\n", num_linea, yytext);
                          fprintf(yyout, "ERROR "); }

%%