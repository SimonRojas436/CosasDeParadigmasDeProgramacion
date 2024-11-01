typedef enum { 
    INICIO, FIN, LEER, ESCRIBIR, ID, CONSTANTE, PARENIZQUIERDO,  
    PARENDERECHO, PUNTOYCOMA, COMA, ASIGNACION, SUMA, RESTA, FDT,
} TOKEN;

const char *Buffer(void);

TOKEN EsReservada(void);

TOKEN Scanner(void);
