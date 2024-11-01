#include "scanner.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define TAMANIO_BUFFER 20
#define ERROR -1

typedef int ESTADO;

char _buffer[TAMANIO_BUFFER+1];
int  _pos = 0;

void LimpiarBuffer(void) {
    _pos = 0;  // Reinicia la posición para el próximo token.
    _buffer[0] = '\0';  // Limpia el primer carácter para asegurar que el buffer esté vacío.
}

void AgregarCaracter(int caracter) {
    //if(_pos < TAMANIO_BUFFER)
        _buffer[_pos++] = caracter;
}

const char *Buffer(void) {
    _buffer[_pos] = '\0';
    return _buffer;
}

TOKEN EsReservada(void) {
    if (strcmp(_buffer, "inicio") == 0) return INICIO;
    if (strcmp(_buffer, "fin") == 0) return FIN;
    if (strcmp(_buffer, "leer") == 0) return LEER;
    if (strcmp(_buffer, "escribir") == 0) return ESCRIBIR;
    return ID;
}

int ObtenerColumna(int simbolo) {
    if (isalpha(simbolo)) {  
        return 0;
    } else if (isdigit(simbolo)) {
        return 1;
    } else if (isspace(simbolo)) {
        return 11;
    }

    switch (simbolo) {
        case '+': return 2;
        case '-': return 3;
        case '(': return 4;
        case ')': return 5;
        case ',': return 6;
        case ';': return 7;
        case ':': return 8;
        case '=': return 9;
        case -1: return 10;
        default: return 12;
    }
}

ESTADO Transicion(ESTADO estado, int simbolo) {
    static ESTADO TT[15][13] = {
    // 0   1   2   3   4   5   6   7   8   9  10   11  12 //
    // L   D   +   -   (   )   ,   ;   :   =  fdt  sp otro
    {  1,  3,  5,  6,  7,  8,  9, 10, 11, 14, 13,  0, 14 }, // Estado 0-
    {  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2 }, // Estado 1
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 2+
    {  4,  3,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4 }, // Estado 3
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 4+
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 5+
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 6+
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 7+
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 8+
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 9+
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 10+
    { 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 14, 14, 14 }, // Estado 11
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 12+
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 13+
    { 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99 }, // Estado 14

    };
    
    int columna = ObtenerColumna(simbolo);
    if (columna == 12) // Columna "otro" (no reconocido)
        return ERROR; // Devuelve un error
    return TT[estado][columna];
}

TOKEN Scanner(void) {
    TOKEN token = 0;
    int c;
    ESTADO estado = 0;
    LimpiarBuffer();
    while ((c = getchar()) != EOF) {
        estado = Transicion(estado, c);
         if (estado == ERROR) {
            if(_buffer[0] != '\0')
            {
                Buffer();
                ungetc(c, stdin);
                token = EsReservada(); //Revisar
                return token; /* ID */
            }
            fprintf(stderr, "Error: simbolo no reconocido '%c'\n", c);
            fprintf(stderr, "Error en el analisis lexico. Continuando...\n");
            LimpiarBuffer();  // Limpia el buffer
            estado = 0;       // Reinicia el estado
            continue;         // Continua con el siguiente caracter
        }
        switch (estado) {
            case 1:
            case 3:
                AgregarCaracter(c);
                break;
            case 2:
                Buffer();
                ungetc(c, stdin);
                token = EsReservada();
                return token; /* ID */
            case 4:
                ungetc(c, stdin);
                return CONSTANTE; 
            case 5:
                AgregarCaracter(c);
                return SUMA; 
            case 6:
                AgregarCaracter(c);
                return RESTA; 
            case 7:
                AgregarCaracter(c);
                return PARENIZQUIERDO; 
            case 8:
                AgregarCaracter(c);
                return PARENDERECHO; 
            case 9:
                AgregarCaracter(c);
                return COMA; 
            case 10:
                AgregarCaracter(c);
                return PUNTOYCOMA; 
            case 11:
                AgregarCaracter(c);
                break;
            case 12:
                AgregarCaracter(c);
                return ASIGNACION; 
            case 99:
                return FDT; 
            case 13:
                return FDT; 
        }
    }
    return FDT;
}