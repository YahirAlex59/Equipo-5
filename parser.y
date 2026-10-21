%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int num_linea;
extern FILE *yyin;
extern FILE *yyout;

void yyerror(const char *s);

FILE *dot_file;
int node_count = 0;

int crear_nodo(const char *etiqueta) {
    if (!etiqueta) etiqueta = "NULO";
    int id = ++node_count;
    if (etiqueta[0] == '"') {
        int len = strlen(etiqueta);
        fprintf(dot_file, "    node%d [label=\"\\\"%.*s\\\"\"];\n", id, len - 2, etiqueta + 1);
    } else {
        fprintf(dot_file, "    node%d [label=\"%s\"];\n", id, etiqueta);
    }
    return id;

void conectar(int padre, int hijo) {
    if (hijo != 0) {
        fprintf(dot_file, "    node%d -> node%d;\n", padre, hijo);
    }
}
%}

%union {
    char *str;
    int nodo;
}

%token <str> TIPO BOOLEANO DECIMAL ENTERO CARACTER CADENA VARIABLE
%token MOSTRAR DEFINE
%token SUMA RESTA MULT DIV
%token IGUAL ASIGNACION MENOR MAYOR PUNTOYCOMA

%left IGUAL MENOR MAYOR
%left SUMA RESTA
%left MULT DIV

%type <nodo> sentencia declaracion

%start programa

%%

programa
    : programa sentencia {
        conectar(1, $2);
    }
    | sentencia {
        conectar(1, $1);
    }
    ;

sentencia
    : declaracion PUNTOYCOMA { $$ = $1; }
    | asignacion PUNTOYCOMA  { $$ = $1; }
    | impresion PUNTOYCOMA   { $$ = $1; }
    ;

declaracion
    : TIPO VARIABLE ASIGNACION expresion {
        $$ = crear_nodo("DECLARACION");
        conectar($$, crear_nodo($1));
        conectar($$, crear_nodo($2));
        conectar($$, $4);
    }
    | TIPO VARIABLE {
        $$ = crear_nodo("DECLARACION");
        conectar($$, crear_nodo($1));
        conectar($$, crear_nodo($2));
    }
    | DEFINE VARIABLE ASIGNACION expresion {
        $$ = crear_nodo("DEFINE");
        conectar($$, crear_nodo($2));
        conectar($$, $4);
    }
    ;