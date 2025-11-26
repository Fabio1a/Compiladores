%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yylineno;
extern char *yytext;

void yyerror(const char *s);
%}

/* Definición de Tokens que vienen del Lexer */
%token INT FLOAT VOID RETURN
%token ID NUMBER
%token ASSIGN PLUS MINUS MULT DIV
%token LBRACE RBRACE LPAREN RPAREN SEMICOLON COMMA

/* Precedencia de operadores (para matemáticas correctas) */
%left PLUS MINUS
%left MULT DIV

/* Estructura general del programa */
%%

program:
    declaration_list
    ;

declaration_list:
    declaration_list declaration
    | declaration
    ;

declaration:
    var_declaration
    | fun_declaration
    ;

/* Declaración de variables: int x; */
var_declaration:
    type_specifier ID SEMICOLON
    | type_specifier ID ASSIGN expression SEMICOLON
    ;

type_specifier:
    INT
    | FLOAT
    | VOID
    ;

/* Declaración de funciones: int main() { ... } */
fun_declaration:
    type_specifier ID LPAREN params RPAREN block
    ;

params:
    param_list
    | /* vacio */
    ;

param_list:
    param_list COMMA param
    | param
    ;

param:
    type_specifier ID
    ;

/* Bloques de código { ... } */
block:
    LBRACE local_declarations statement_list RBRACE
    ;

local_declarations:
    local_declarations var_declaration
    | /* vacio */
    ;

statement_list:
    statement_list statement
    | /* vacio */
    ;

statement:
    expression_stmt
    | return_stmt
    | block
    | error SEMICOLON { yyerrok; } /* Recuperación de errores simple */
    ;

expression_stmt:
    expression SEMICOLON
    | SEMICOLON
    ;

return_stmt:
    RETURN expression SEMICOLON
    | RETURN SEMICOLON
    ;

expression:
    var_assign
    | simple_expression
    ;

var_assign:
    ID ASSIGN expression
    ;

simple_expression:
    simple_expression PLUS term
    | simple_expression MINUS term
    | term
    ;

term:
    term MULT factor
    | term DIV factor
    | factor
    ;

factor:
    LPAREN expression RPAREN
    | ID
    | NUMBER
    | call /* Llamadas a función */
    ;

call:
    ID LPAREN args RPAREN
    ;

args:
    arg_list
    | /* vacio */
    ;

arg_list:
    arg_list COMMA expression
    | expression
    ;

%%

/* Función principal y manejo de errores */
int main(int argc, char **argv) {
    extern FILE *yyin;
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error al abrir el archivo");
            return 1;
        }
    }
    printf("Iniciando analisis sintactico...\n");
    yyparse();
    printf("Analisis finalizado.\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error sintactico en linea %d: %s cerca de '%s'\n", yylineno, s, yytext);
}