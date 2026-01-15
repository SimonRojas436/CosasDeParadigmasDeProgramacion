/*SUENÑOS:
Un consorcio internacional nos pidió que relevemos su negocio, que consiste en hacer el seguimiento de los sueños
que tiene cada una de las personas y los personajes que están destinados a cumplir esos sueños.*/

/*PUNTO 1:
Queremos reflejar que:
    - Gabriel cree en Campanita, el Mago de Oz y Cavenaghi.
    - Juan cree en el Conejo de Pascua.
    - Macarena cree en los Reyes Magos, el Mago Capria y Campanita.
    - Diego no cree en nadie.
Conocemos tres tipos de sueño:
    - Ser un cantante y vender una cierta cantidad de “discos” (≅ bajadas).
    - Ser un futbolista y jugar en algún equipo.
    - Ganar la lotería apostando una serie de números.
Queremos reflejar entonces que...
    - Gabriel quiere ganar la lotería apostando al 5 y al 9, y también quiere ser un futbolista de Arsenal
    - Juan quiere ser un cantante que venda 100.000 “discos”
    - Macarena no quiere ganar la lotería, sí ser cantante estilo “Eruca Sativa” y vender 10.000 discos
B. Generar la base de conocimientos inicial.
A. Indicar qué conceptos entraron en juego para cada punto.*/

creeEn(gabriel, campanita).
creeEn(gabriel, elMagoDeOz).
creeEn(gabriel, cavenaghi).
creeEn(juan, conejoDePascua).
creeEn(macarena, reyesMagos).
creeEn(macarena, elMagoCapria).
creeEn(macarena, campanita).

sueniaCon(gabriel, ganarLaLoteria([5, 9])).
sueniaCon(gabriel, serFutbolista(arsenal)).
sueniaCon(juan, serCantante(100000)).
sueniaCon(macarena, serCantante(100000)).



/*PUNTO 2:
Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los sueños es mayor a 20.
La dificultad de cada sueño se calcula como:
    - 6 para ser un cantante que vende más de 500.000 ó 4 en caso contrario.
    - Ganar la lotería implica una dificultad de 10 por la cantidad de los números apostados.
    - Lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y Aldosivi
      son equipos chicos.
Puede agregar los predicados que sean necesarios. El predicado debe ser inversible para todos sus argumentos.
Ejemplo: Gabriel es ambicioso, porque quiere ganar a la lotería con 2 números (20 puntos de dificultad) y quiere ser
futbolista de Arsenal (3 puntos) = 23 que es mayor a 20. En cambio Juan y Macarena tienen 4 puntos de dificultad
(cantantes con menos de 500.000 discos).*/

dificultad(serCantante(Bajadas), 6) :- Bajadas > 500000.
dificultad(serCantante(Bajadas), 4) :- Bajadas =< 500000.

dificultad(ganarLaLoteria(NumerosApostados), Dificultad) :-
    length(NumerosApostados, CantNumerosApostados),
    Dificultad is (10 * CantNumerosApostados).

dificultad(serFutbolista(Equipo), 16) :- Equipo \= arsenal, Equipo \= aldosivi.
dificultad(serFutbolista(arsenal), 3).
dificultad(serFutbolista(aldosivi), 3).

esAmbiciosa(Persona) :- 
    sumaDeDificultadesDeLosSuenios(Persona, SumaSuenios),
    SumaSuenios > 20.

sumaDeDificultadesDeLosSuenios(Persona, SumaSuenios) :-
    sueniaCon(Persona, _),
    findall(Dificultad, dificultadSuenio(Persona, Dificultad), ListaDificultades),
    sum_list(ListaDificultades, SumaSuenios).

dificultadSuenio(Persona, Dificultad) :-
    sueniaCon(Persona, Suenio),
    dificultad(Suenio, Dificultad).



/*PUNTO 3:
Queremos saber si un personaje tiene química con una persona. Esto se da si la persona cree en el personaje y...
    - Para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
    - Para el resto, ○ todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos) ○ y la
      persona no debe ser ambiciosa
No puede utilizar findall en este punto.
El predicado debe ser inversible para todos sus argumentos.
Campanita tiene química con Gabriel (porque tiene como sueño ser futbolista de Arsenal, que es un sueño de dificultad
(3, menor a 5), y los Reyes Magos, el Mago Capria y Campanita tienen química con Macarena porque no es ambiciosa.*/

tieneQuimicaCon(Personaje, Persona) :-
    creeEn(Persona, Personaje),
    Personaje \= campanita,
    todosLosSueniosSonPuros(Persona),
    not(esAmbiciosa(Persona)).

tieneQuimicaCon(campanita, Persona) :-
    creeEn(Persona, campanita),
    sueniaCon(Persona, _),
    dificultadSuenio(_, Dificultad),
    Dificultad < 5.

todosLosSueniosSonPuros(Persona) :-
    sueniaCon(Persona, _),
    forall(sueniaCon(Persona, Suenio), esPuro(Suenio)).

esPuro(serFutbolista(_)).
esPuro(serCantante(Bajadas)) :- Bajadas < 200000.



/*punto 4:
Sabemos que:
    - Campanita es amiga de los Reyes Magos y del Conejo de Pascua.
    - El Conejo de Pascua es amigo de Cavenaghi, entre otras amistades.
Necesitamos definir si un personaje puede alegrar a una persona, esto ocurre
    - Si una persona tiene algún sueño
    - El personaje tiene química con la persona y...
        A. El personaje no está enfermo.
        B. Algún personaje de backup no está enfermo. Un personaje de backup es un amigo directo o indirecto del
           personaje principal.
Debe evitar repetición de lógica. El predicado debe ser totalmente inversible. Debe considerar cualquier nivel de
amistad posible (la solución debe ser general). Suponiendo que Campanita, los Reyes Magos y el Conejo de Pascua están
enfermos:
    - El Mago Capria alegra a Macarena, ya que tiene química con ella y no está enfermo.
    - Campanita alegra a Macarena; aunque está enferma es amiga del Conejo de Pascua, que aunque está enfermo es amigo
      de Cavenaghi que no está enfermo.*/

esAmigoDe(campanita, reyesMagos).
esAmigoDe(campanita, conejoDePascua).
esAmigoDe(conejoDePascua, cavenaghi).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).

/*SUPONIENDO QUE SIEMPRE HABRÁ UN BACKUP QUE NO ESTÉ ENFERMO:*/*
puedeAlegrar(Personaje, Persona) :-
    sueniaCon(Persona, _),
    tieneQuimicaCon(Personaje, Persona),
    not(amigoSano(Personaje)).

amigoSano(Personaje) :-
    estaEnfermo(Personaje),
    esAmigoDe(Personaje, AmigoPersonaje),
    amigoSano(AmigoPersonaje).*/