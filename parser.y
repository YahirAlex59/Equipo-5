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
}
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

%type <nodo> sentencia declaracion asignacion impresion expresion

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
asignacion
    : VARIABLE ASIGNACION expresion {
        $$ = crear_nodo("=");
        conectar($$, crear_nodo($1));
        conectar($$, $3);
    }
    ;

impresion
    : MOSTRAR expresion {
        $$ = crear_nodo("IMPRIMIR");
        conectar($$, $2);
    }
    ;

expresion
    : expresion SUMA expresion  { $$ = crear_nodo("+");  conectar($$, $1); conectar($$, $3); }
    | expresion RESTA expresion { $$ = crear_nodo("-");  conectar($$, $1); conectar($$, $3); }
    | expresion MULT expresion  { $$ = crear_nodo("*");  conectar($$, $1); conectar($$, $3); }
    | expresion DIV expresion   { $$ = crear_nodo("/");  conectar($$, $1); conectar($$, $3); }
    | expresion IGUAL expresion { $$ = crear_nodo("=="); conectar($$, $1); conectar($$, $3); }
    | expresion MENOR expresion { $$ = crear_nodo("<");  conectar($$, $1); conectar($$, $3); }
    | expresion MAYOR expresion { $$ = crear_nodo(">");  conectar($$, $1); conectar($$, $3); }
    | ENTERO                    { $$ = crear_nodo($1); }
    | DECIMAL                   { $$ = crear_nodo($1); }
    | BOOLEANO                  { $$ = crear_nodo($1); }
    | CARACTER                  { $$ = crear_nodo($1); }
    | CADENA                    { $$ = crear_nodo($1); }
    | VARIABLE                  { $$ = crear_nodo($1); }
    ;

%%

void yyerror(const char *s) {
    printf("Error sintactico en la linea %d: %s\n", num_linea, s);
}

int main(void) {
    yyin = fopen("programac.txt", "r");
    yyout = fopen("salida.txt", "w");
    dot_file = fopen("arbol.dot", "w");

    if (!yyin)  { perror("No se pudo abrir programac.txt"); return 1; }
    if (!yyout) { perror("No se pudo abrir salida.txt"); fclose(yyin); return 1; }

    fprintf(dot_file, "digraph AST {\n");
    fprintf(dot_file, "    node [shape=box, fontname=\"Arial\"];\n");

    crear_nodo("PROGRAMA");

    printf("Analizando sintaxis de programac.txt...\n");

    if (yyparse() == 0) {
        printf("Sintaxis correcta! Archivo arbol.dot y salida.txt generados.\n");
    }

    fprintf(dot_file, "}\n");

    fclose(dot_file);
    fclose(yyin);
    fclose(yyout);
    return 0;
}