int globalVar;

int suma(int a, int b) {
    int resultado;
    resultado = a + b;
    
    /* Error 1: Variable no declarada */
    x = 10; 

    return resultado;
}

int main() {
    int localMain;
    localMain = 5;

    /* Valido: Usar variable global */
    globalVar = 10;

    /* Error 2: Redeclaracion de variable en el mismo scope */
    int localMain;

    /* Error 3: Usar variable 'resultado' que es local de 'suma' (Scope incorrecto) */
    resultado = 0;

    return 0;
}