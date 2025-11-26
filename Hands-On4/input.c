#include <stdlib.h>
#include <stdio.h>
#define SCALE_FACTOR 2

int globalA;
int globalB;

int addValues(int first, int second) {
    int resultLocal;
    resultLocal = first + second;
    return resultLocal;
}

int processValue(int value) {
    int temporaryVal;
    temporaryVal = value * SCALE_FACTOR;
    {
        /* nested block */
        int innerResult;
        innerResult = temporaryVal + 5;
        printf("%d\n", innerResult);
    }
    return temporaryVal;
}

int main() {
    int resultMain;
    int auxValue;

    globalA = 3;
    globalB = 4;

    resultMain = addValues(globalA, globalB);
    printf("%d\n", resultMain);

    auxValue = processValue(resultMain);
    printf("%d\n", auxValue);

    int finalOutput;
    finalOutput = auxValue + resultMain;
    printf("%d\n", finalOutput);

    return 0;
}

