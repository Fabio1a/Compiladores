# Hands-on 5: Analizador Sintáctico (Flex + Bison)

## Integrantes
* [Tu Nombre]

## Descripción
Analizador sintáctico para un subconjunto de C. Utiliza **Flex** para obtener tokens y **Bison** para validar la gramática libre de contexto.
Soporta:
* Declaraciones de variables y funciones.
* Bloques de código `{}`.
* Expresiones aritméticas con precedencia (`*` y `/` primero).
* Sentencias `return` y llamadas a funciones.

## Compilación y Ejecución (Linux/WSL)

1. Generar el parser (Bison):
   `bison -d parser.y`
   *(Esto genera parser.tab.c y parser.tab.h)*

2. Generar el lexer (Flex):
   `flex lexer.l`

3. Compilar todo junto con GCC:
   `gcc parser.tab.c lex.yy.c -o analizador`

4. Ejecutar:
   `./analizador input.c`