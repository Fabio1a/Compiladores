%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
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

{ID}        { yylval.str = strdup(yytext); return ID; } /* IMPORTANTE: Guardamos el nombre */
{NUMBER}    { yylval.num = atoi(yytext); return NUMBER; }

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

"#include".* { }
"#define".* { }

{WHITESPACE} { }

.           { printf("Error lexico: %s\n", yytext); }

%%

int yywrap() { return 1; }