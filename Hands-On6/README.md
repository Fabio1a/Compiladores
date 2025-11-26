# Hands-on 6: Análisis Semántico

# Integrantes
- Jonathan Guillermo Ramos Flores
- Fabiola Escobedo Quezada

#Descripción
Este analizador extiende el parser anterior implementando validaciones semánticas mediante una **Tabla de Símbolos** y una **Pila de Scopes (implícita)**.

# Validaciones Implementadas
1. Detección de variables no declaradas:** Si intentas usar `x = 5;` sin haber puesto `int x;`, marcará error.
2. Detección de redeclaraciones:** Si pones `int x;` dos veces en la misma función, marcará error.
3. Manejo de Scopes (Local vs Global):**
- Las variables declaradas dentro de una función `{ ... }` se eliminan al salir de ella.
- No puedes acceder a una variable local de otra función.

#Compilación y Ejecución (Linux/WSL)

1. Bison:
   'bison -d parser.y'

2. Flex:
   'flex lexer.l'

3. GCC:
   'gcc parser.tab.c lex.yy.c -o semantico'

4. Ejecutar:
   './semantico input.c'