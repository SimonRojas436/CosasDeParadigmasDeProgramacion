#include <stdio.h>
#include "scanner.h"

int main(void) {
    TOKEN token;
    while ((token = Scanner()) != FDT) {
        printf("%d->%s\n", token, Buffer());
    }
}
