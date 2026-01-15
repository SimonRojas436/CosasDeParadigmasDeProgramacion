/*Llegó el momento de armar las valijas y emprender el hermoso viaje... de programar en Lógico! Necesitamos modelar la
información que se detalla a continuación.*/

/*PUNTO 1: EL DESTINO ES ASÍ, LO SÉ...
Sabemos que Dodain se va a Pehuenia, San Martín (de los Andes), Esquel, Sarmiento, Camarones y Playas Doradas. Alf, en
cambio, se va a Bariloche, San Martín de los Andes y El Bolsón. Nico se va a Mar del Plata, como siempre. Y Vale se va
para Calafate y El Bolsón.
    - Además Martu se va donde vayan Nico y Alf.
    - Juan no sabe si va a ir a Villa Gesell o a Federación.
    - Carlos no se va a tomar vacaciones por ahora.
Se pide que defina los predicados correspondientes, y justifique sus decisiones en base a conceptos vistos en la cursada.*/

persona(dodain).
persona(alf).
persona(nico).
persona(vale).
persona(martu).

seVaA(dodain, pehuenia).
seVaA(dodain, sanMartin).
seVaA(dadain, esquel).
seVaA(dodain, sarmiento).
seVaA(dodain, camarones).
seVaA(dodain, playasDoradas).
seVaA(alf, bariloche).
seVaA(alf, sanMartin).
seVaA(alf, elBolson).
seVaA(nico, marDelPlata).
seVaA(vale, elCalafate).
seVaA(vale, elBolson).
seVaA(martu, Destino) :- seVaA(nico, Destino).
seVaA(martu, Destino) :- seVaA(alf, Destino).

/*PUNTO 2: VACACIONES COPADAS.
Incorporamos ahora información sobre las atracciones de cada lugar. Las atracciones se dividen en:
    - Un parque nacional, donde sabemos su nombre.
    - Un cerro, sabemos su nombre y la altura.
    - Un cuerpo de agua (cuerpoAgua, río, laguna, arroyo), sabemos si se puede pescar y la temperatura promedio del agua.
    - Una playa: tenemos la diferencia promedio de marea baja y alta.
    - Una excursión: sabemos su nombre.
    Agregue hechos a la base de conocimientos de ejemplo para dejar en claro cómo modelaría las atracciones. Por ejemplo:
Esquel tiene como atracciones un parque nacional (Los Alerces) y dos excursiones (Trochita y Trevelin). Villa Pehuenia
tiene como atracciones un cerro (Batea Mahuida de 2.000 m) y dos cuerpos de agua (Moquehue, donde se puede pescar y tiene
14 grados de temperatura promedio y Aluminé, donde se puede pescar y tiene 19 grados de temperatura promedio).*/

/*
atraccion(parqueNacional(Nombre)).
atraccion(cerro(Nombre, Altura)).
atraccion(cuerpoDeAgua(Tipo, Pesca, Temperatura)).
atraccion(playa(DiferenciaMarea)).
atraccion(excursion(Nombre)).
*/

atraccionesDe(esquel, [parqueNacional(losAlerces), excursion(trochita), excursion(trevelin)]).
atraccionesDe(pehuenia, [cerro(bateaMahuida, 2000), cuerpoDeAgua(cuerpoDeAgua, puedePescar, 14), cuerpoDeAgua(cuerpoDeAgua, puedePescar, 19)]).

    /*Queremos saber qué vacaciones fueron copadas para una persona. Esto ocurre cuando todos los lugares a visitar tienen por lo
menos una atracción copada.
    - Un cerro es copado si tiene más de 2000 metros.
    - Un cuerpoAgua es copado si se puede pescar o la temperatura es mayor a 20.
    - Una playa es copada si la diferencia de mareas es menor a 5.
    - Una excursión que tenga más de 7 letras es copado.
    - Cualquier parque nacional es copado.
El predicado debe ser inversible.*/

atraccionCopada(parqueNacional(_)).
atraccionCopada(cerro(_, Altura)) :- Altura > 2000.
atraccionCopada(cuerpoDeAgua(_, puedePescar, Temperatura)) :- Temperatura > 20.
atraccionCopada(playa(DiferenciaMarea)) :- DiferenciaMarea < 5.
%atraccionCopada(excursion(Nombre)).

vacacionesCopadas(Persona) :-
    persona(Persona),
    forall(seVaA(Persona, Destino), hayUnaCopada(Destino)).

hayUnaCopada(Destino) :-
    atraccionesDe(Destino, Atracciones),
    member(Atraccion, Atracciones),
    esCopada(Atraccion).

esCopada(Atraccion) :- atraccionCopada(Atraccion).

/*PUNTO 3: NI SE ME CRUZÓ POR LA CABEZA...
Cuando dos personas distintas no coinciden en ningún lugar como destino decimos que no se cruzaron. Por ejemplo, Dodain
no se cruzó con Nico ni con Vale (sí con Alf en San Martín de los Andes). Vale no se cruzó con Dodain ni con Nico (sí
con Alf en El Bolsón). El predicado debe ser completamente inversible.*/

noSeCruzo(Persona, OtraPersona) :-
    persona(Persona),
    persona(OtraPersona),
    Persona \= OtraPersona,
    forall(seVaA(Persona, Destino), not(seVaA(OtraPersona, Destino))).



/*PUNTO 4: VACACIONES GASOLERAS.
Incorporamos el costo de vida de cada destino:
    Queremos saber si unas vacaciones fueron gasoleras para una persona. Esto ocurre si todos los destinos son gasoleros,
    es decir, tienen un costo de vida menor a 160. Alf, Nico y Martu hicieron vacaciones gasoleras.
El predicado debe ser inversible.*/

costoVida(sarmiento, 100).
costoVida(esquel, 150).
costoVida(pehuenia, 180).
costoVida(sanMartin, 150).
costoVida(camarones, 135).
costoVida(playasDoradas, 170).
costoVida(bariloche, 140).
costoVida(elCalafate, 240).
costoVida(elBolson, 145).
costoVida(marDelPlata, 140).

vacacionesGasoleras(Persona) :-
    persona(Persona),
    forall(seVaA(Persona, Destino), esGasolero(Destino)).

esGasolero(Destino) :- costoVida(Destino, CostoVida), CostoVida < 160.





    /*CONJUNTO DE PARTES:
itinerarios(Persona, ItinerarioPosible) :-
    persona(Persona),
    findall(Destino, seVaA(Persona, Destino), ListaDestinos),
    length(ListaDestinos, CantDestinos),
    itinerariosPosibles(ListaDestinos, CantDestinos, ItinerarioPosible).

itinerariosPosibles([], _, []).

itinerariosPosibles([Destino|RestoDestinos], CantDestinos, [Destino|RestoItinerario]) :-
    RestoCantDestinos is CantDestinos - 1,
    itinerariosPosibles(RestoDestinos, RestoCantDestinos, RestoItinerario).

itinerariosPosibles([_|RestoDestinos], CantDestinos, RestoItinerario) :-
    itinerariosPosibles(RestoDestinos, CantDestinos, RestoItinerario).
    */




