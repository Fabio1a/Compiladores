/* lexer.l */
%{
#include <stdio.h>
%}

/* Definiciones básicas */
DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*
NUMBER      {DIGIT}+
WHITESPACE  [ \t\r\n]+

/* Estados para manejar comentarios de bloque */
%x COMMENT

%%

"/*"            { BEGIN(COMMENT); printf("COMENTARIO_INICIO: /*\n"); }
<COMMENT>"*/"   { BEGIN(INITIAL); printf("COMENTARIO_FIN: */\n"); }
<COMMENT>(.|\n) { /* Ignorar contenido dentro del comentario */ }

"//".* { printf("COMENTARIO_LINEA: %s\n", yytext); }

"#include"      { printf("DIRECTIVA: %s\n", yytext); }
"#define"       { printf("DIRECTIVA: %s\n", yytext); }

"int"           { printf("PALABRA_RESERVADA: %s\n", yytext); }
"float"         { printf("PALABRA_RESERVADA: %s\n", yytext); }
"double"        { printf("PALABRA_RESERVADA: %s\n", yytext); }
"char"          { printf("PALABRA_RESERVADA: %s\n", yytext); }
"void"          { printf("PALABRA_RESERVADA: %s\n", yytext); }
"short"         { printf("PALABRA_RESERVADA: %s\n", yytext); }
"return"        { printf("PALABRA_RESERVADA: %s\n", yytext); }

{ID}            { printf("IDENTIFICADOR: %s\n", yytext); }
{NUMBER}        { printf("ENTERO: %s\n", yytext); }

"+"             { printf("OPERADOR: +\n"); }
"-"             { printf("OPERADOR: -\n"); }
"*"             { printf("OPERADOR: *\n"); }
"/"             { printf("OPERADOR: /\n"); }
"="             { printf("OPERADOR: =\n"); }
"++"            { printf("OPERADOR: ++\n"); }

"("             { printf("DELIMITADOR: (\n"); }
")"             { printf("DELIMITADOR: )\n"); }
"{"             { printf("DELIMITADOR: {\n"); }
"}"             { printf("DELIMITADOR: }\n"); }
";"             { printf("DELIMITADOR: ;\n"); }
","             { printf("DELIMITADOR: ,\n"); }
"<"             { printf("DELIMITADOR: <\n"); }
">"             { printf("DELIMITADOR: >\n"); }

{WHITESPACE}    { /* Ignorar espacios en blanco */ }

.               { printf("ERROR_LEXICO: Caracter no reconocido '%s'\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error al abrir el archivo");
            return 1;
        }
    }
    yylex();
    return 0;
}