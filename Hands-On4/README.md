# Hands-on 4: Analizador Léxico

# Integrantes del Equipo
* Jonathan Guillermo Ramos Flores
* Fabiola Escobedo Quezada

# Descripción
Este analizador léxico está implementado en C utilizando Flex. Es capaz de tokenizar un archivo fuente de lenguaje C, reconociendo:
- Directivas de preprocesador: #include, #define.
- Palabras reservadas:** int, void, return, char, float, etc.
- Identificadores:** Nombres de variables y funciones.
- Constantes numéricas:** Números enteros.
- Operadores:** +, -, *, /, =, ++.
- Delimitadores:** (, ), {, }, ;, ,.
- Comentarios:** Soporta comentarios de una línea (//) y bloques (/* ... */).

# Instrucciones de Compilación y Ejecución

Requisitos
- Tener instalado `flex` y `gcc`.

# Compilación
Para generar el código C del analizador y compilar el ejecutable:

```bash
flex lexer.l
gcc lex.yy.c -o analizador