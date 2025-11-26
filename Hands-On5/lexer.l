%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h" /* Importante: Bison generará este archivo */
%}

%option yylineno

DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*
NUMBER      {DIGIT}+
WHITESPACE  [ \t\r\n]+

%%

"/*"([^*]|(\*+[^*/]))*\*+"/" { /* Ignorar comentarios bloque */ }
"//".* { /* Ignorar comentarios linea */ }

"int"       { return INT; }
"float"     { return FLOAT; }
"void"      { return VOID; }
"return"    { return RETURN; }

{ID}        { return ID; }
{NUMBER}    { return NUMBER; }

"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULT; }
"/"         { return DIV; }

"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }
","         { return COMMA; }

"#include".* { /* Ignorar preprocesador por simplicidad en sintáctico */ }
"#define".* { /* Ignorar preprocesador por simplicidad en sintáctico */ }

{WHITESPACE} { /* Ignorar */ }

.           { printf("Error lexico: caracter desconocido %s\n", yytext); }

%%

int yywrap() {
    return 1;
}