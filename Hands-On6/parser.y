%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char *yytext;
void yyerror(const char *s);

/* --- ESTRUCTURAS DE LA TABLA DE SÍMBOLOS --- */

typedef struct Symbol {
    char *name;
    int type;       /* 0: VAR, 1: FUNC */
    int scope;      /* 0: Global, 1+: Local */
    int param_count; /* Solo para funciones */
    struct Symbol *next;
} Symbol;

Symbol *symbol_table = NULL;
int current_scope = 0; /* 0 = Global */

/* Funciones auxiliares */
void add_symbol(char *name, int type);
Symbol* find_symbol(char *name);
void check_variable_exists(char *name);
void check_function_exists(char *name);
void increase_scope();
void decrease_scope();

%}

/* Unión para manejar tanto enteros como cadenas (nombres de variables) */
%union {
    int num;
    char *str;
}

/* Tokens */
%token <str> ID
%token <num> NUMBER
%token INT FLOAT VOID RETURN
%token ASSIGN PLUS MINUS MULT DIV
%token LBRACE RBRACE LPAREN RPAREN SEMICOLON COMMA

/* Precedencia */
%left PLUS MINUS
%left MULT DIV

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

/* Declaración de variables */
var_declaration:
    type_specifier ID SEMICOLON {
        add_symbol($2, 0); /* 0 = Variable */
    }
    | type_specifier ID ASSIGN expression SEMICOLON {
        add_symbol($2, 0);
    }
    ;

type_specifier:
    INT | FLOAT | VOID
    ;

/* Declaración de funciones */
fun_declaration:
    type_specifier ID LPAREN {
        add_symbol($2, 1); /* 1 = Funcion */
        increase_scope(); /* Entramos al scope de la función */
    } params RPAREN block {
        /* Al terminar la función, bajamos el scope manualmente si el bloque no lo hizo */
        /* Nota: El bloque ya maneja el decrease_scope, asi que aqui solo ajustamos logica */
    }
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
    type_specifier ID {
        add_symbol($2, 0); /* Parametros cuentan como variables locales */
    }
    ;

/* Bloques { ... } con manejo de Scope */
block:
    LBRACE { 
        /* Si NO venimos de declarar funcion (logica simple), podriamos aumentar scope.
           Para este ejemplo simple, asumimos que increase_scope se llama antes. */
    } 
    local_declarations statement_list 
    RBRACE {
        decrease_scope(); /* Al cerrar llave, destruimos variables locales */
    }
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
    | block { increase_scope(); } /* Bloque anidado (if/while simulado) */
    | SEMICOLON
    ;

expression_stmt:
    expression SEMICOLON
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
    ID ASSIGN expression {
        check_variable_exists($1); /* VALIDACIÓN SEMÁNTICA: ¿Existe la variable? */
    }
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
    | ID { 
        check_variable_exists($1); /* VALIDACIÓN SEMÁNTICA */
    }
    | NUMBER
    | call
    ;

call:
    ID LPAREN args RPAREN {
        check_function_exists($1); /* VALIDACIÓN SEMÁNTICA */
    }
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

/* --- CÓDIGO C: IMPLEMENTACIÓN DE TABLA DE SÍMBOLOS --- */

void add_symbol(char *name, int type) {
    /* Verificar si ya existe EN EL SCOPE ACTUAL para detectar redeclaración */
    Symbol *ptr = symbol_table;
    while (ptr != NULL) {
        if (strcmp(ptr->name, name) == 0 && ptr->scope == current_scope) {
            fprintf(stderr, "Error Semantico (Linea %d): Redeclaracion de '%s'\n", yylineno, name);
            return; /* No agregamos duplicados */
        }
        ptr = ptr->next;
    }

    /* Agregar nuevo símbolo al inicio de la lista */
    Symbol *new_sym = (Symbol *)malloc(sizeof(Symbol));
    new_sym->name = strdup(name);
    new_sym->type = type;
    new_sym->scope = current_scope;
    new_sym->next = symbol_table;
    symbol_table = new_sym;
    
    printf("-> Declarado: %s (Scope: %d, Tipo: %s)\n", name, current_scope, type==0?"Var":"Func");
}

Symbol* find_symbol(char *name) {
    Symbol *ptr = symbol_table;
    while (ptr != NULL) {
        if (strcmp(ptr->name, name) == 0) {
            /* Reglas de visibilidad: Podemos ver variables globales (scope 0) 
               o variables de nuestro propio scope o scopes padres */
            /* Por simplicidad en este hands-on, si existe en la tabla y es scope <= actual, es visible */
            if (ptr->scope <= current_scope) return ptr;
        }
        ptr = ptr->next;
    }
    return NULL;
}

void check_variable_exists(char *name) {
    Symbol *sym = find_symbol(name);
    if (sym == NULL) {
        fprintf(stderr, "Error Semantico (Linea %d): Variable no declarada '%s'\n", yylineno, name);
    } else if (sym->type == 1) {
        fprintf(stderr, "Error Semantico (Linea %d): '%s' es una funcion, no una variable\n", yylineno, name);
    }
}

void check_function_exists(char *name) {
    Symbol *sym = find_symbol(name);
    if (sym == NULL) {
        fprintf(stderr, "Error Semantico (Linea %d): Funcion no declarada '%s'\n", yylineno, name);
    } else if (sym->type == 0) {
        fprintf(stderr, "Error Semantico (Linea %d): '%s' no es una funcion\n", yylineno, name);
    }
}

void increase_scope() {
    current_scope++;
}

void decrease_scope() {
    /* Al salir de un scope, eliminamos las variables locales de ese scope */
    Symbol *ptr = symbol_table;
    Symbol *prev = NULL;
    
    while (ptr != NULL) {
        if (ptr->scope == current_scope) {
            Symbol *temp = ptr;
            if (prev == NULL) {
                symbol_table = ptr->next;
                ptr = symbol_table;
            } else {
                prev->next = ptr->next;
                ptr = prev->next;
            }
            /* printf("   -> Limpiando variable local '%s' al salir de scope %d\n", temp->name, current_scope); */
            free(temp->name);
            free(temp);
        } else {
            prev = ptr;
            ptr = ptr->next;
        }
    }
    current_scope--;
}

int main(int argc, char **argv) {
    extern FILE *yyin;
    if (argc > 1) yyin = fopen(argv[1], "r");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error Sintactico: %s\n", s);
}