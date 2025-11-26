int globalVar;

int suma(int a, int b) {
    return a + b;
}

int main() {
    int x;
    int y;
    x = 10;
    y = 20;
    
    /* Probando una asignación con suma */
    x = x + y * 2;
    
    suma(x, y);

    return 0;
}