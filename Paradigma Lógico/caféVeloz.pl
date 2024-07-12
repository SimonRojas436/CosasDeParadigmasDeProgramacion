/*CAFÉ VELOZ*/
/*Necesitamos desarrollar una aplicación para una conocida empresa que hace los controles antidóping del fútbol argentino.
Tenemos la siguiente información:*/

jugador(maradona).
jugador(chamot).
jugador(balbo). 
jugador(caniggia).
jugador(passarella).
jugador(pedemonti).
jugador(basualdo).

tomo(maradona, sustancia(efedrina)).
tomo(maradona, compuesto(cafeVeloz)).
tomo(caniggia, producto(cocacola, 2)).
tomo(chamot, compuesto(cafeVeloz)).
tomo(balbo, producto(gatoreit, 2)).

/*PUNTO 1:
Se pide:
Hacer lo que sea necesario para incorporar los siguientes conocimientos:
    - Passarella toma todo lo que no tome Maradona.
    - Pedemonti toma todo lo que toma chamot y lo que toma Maradona.
    - Basualdo no toma coca cola.*/

tomo(passarella, Bebida) :- tomo(_, Bebida), not(tomo(maradona, Bebida)).
tomo(pedemonti, Bebida) :- tomo(chamot, Bebida).
tomo(pedemonti, Bebida) :- tomo(maradona, Bebida).

maximo(cocacola, 3).
maximo(gatoreit, 1).
maximo(naranju, 5).

composicion(cafeVeloz, [efedrina, ajipupa, extasis, whisky, cafe]).

sustanciaProhibida(efedrina). 
sustanciaProhibida(cocaina).



/*PUNTO 2:
Definir el predicado puedeSerSuspendido/1 que relaciona si un jugador puede ser suspendido en base a lo que
tomó. El predicado debe ser inversible.
    - Un jugador puede ser suspendido si tomó una sustancia que está prohibida.
    - Un jugador puede ser suspendido si tomó un compuesto que tiene una sustancia prohibida.
    - Un jugador puede ser suspendido si tomó una cantidad excesiva de un producto (más que el máximo permitido).*/

estaProhibida(sustancia(Sustancia)) :- sustanciaProhibida(Sustancia).

estaProhibida(compuesto(Compuesto)) :-
    composicion(Compuesto, Sustancias),
    member(Sustancia, Sustancias),
    sustanciaProhibida(Sustancia).

estaProhibida(producto(Producto, Cantidad)) :-
    maximo(Producto, CantidadMaxima),
    Cantidad > CantidadMaxima.

puedeSerSuspendido(Jugador) :-
    tomo(Jugador, Bebida),
    estaProhibida(Bebida).



/*PUNTO 3:
Defina el predicado malaInfluencia/2 que relaciona dos jugadores, si ambos pueden ser suspendidos y además se conocen.
Un jugador conoce a sus amigos y a los conocidos de sus amigos.*/

amigo(maradona, caniggia).
amigo(caniggia, balbo).
amigo(balbo, chamot).
amigo(balbo, pedemonti).

malaInfluencia(Jugador, OtroJugador) :-
    ambosPuedenSerSuspendidos(Jugador, OtroJugador),
    conoce(Jugador, OtroJugador).

ambosPuedenSerSuspendidos(Jugador, OtroJugador) :-
    puedeSerSuspendido(Jugador),
    puedeSerSuspendido(OtroJugador).

conoce(Jugador, OtroJugador) :- amigo(Jugador, OtroJugador).

conoce(Jugador, OtroJugador) :-
    amigo(Jugador, Intermedio),
    conoce(Intermedio, OtroJugador).



/*PUNTO 4:
Definir el predicado chanta/1, que se verifica para los médicos que sólo atienden a jugadores que podrían ser suspendidos.
El predicado debe ser inversible.*/

atiende(cahe, maradona).
atiende(cahe, chamot).
atiende(cahe, balbo).
atiende(zin, caniggia).
atiende(cureta, pedemonti).
atiende(cureta, basualdo).

chanta(Medico) :-
    atiende(Medico, _),
    forall(atiende(Medico, Jugador), puedeSerSuspendido(Jugador)).



/*PUNTO 5:
Si conocemos el nivel de alteración en sangre de una sustancia, Definir el predicado cuantaFalopaTiene/2, que relaciona
el nivel de alteración en sangre que tiene un jugador, considerando que:
    - Todos los productos (como la coca cola y el gatoreit), no tienen nivel de alteración (asumir 0).
    - Las sustancias tienen definidas el nivel de alteración en base al predicado nivelFalopez/2.
    - Los compuestos suman los niveles de falopez de cada sustancia que tienen.
El predicado debe ser inversible en ambos argumentos. Ej: el cafeVeloz tiene nivel 130 (120 del éxtasis + 10 de la efedrina,
las sustancias que no tienen nivel se asumen 0).*/

nivelFalopez(efedrina, 10).
nivelFalopez(cocaina, 100).
nivelFalopez(extasis, 120).
nivelFalopez(omeprazol, 5).

alteracion(sustancia(Sustancia), Alteracion) :- nivelFalopez(Sustancia, Alteracion).

alteracion(compuesto(Compuesto), Alteracion) :-
    composicion(Compuesto, Sustancias),
    member(Sustancia, Sustancias),
    nivelFalopez(Sustancia, Alteracion).

nivelAlteracion(Jugador, Alteracion) :-
    tomo(Jugador, Bebida),
    alteracion(Bebida, Alteracion).

cuantaFalopaTiene(Jugador, CantidadFalopa) :-
    jugador(Jugador),
    findall(Alteracion, nivelAlteracion(Jugador, Alteracion), ListaFalopera),
    sum_list(ListaFalopera, CantidadFalopa).



/*PUNTO 6:
Definir el predicado medicoConProblemas/1, que se satisface si un médico atiende a más de 3 jugadores conflictivos,
esto es:
    - Que pueden ser suspendidos.
    - Que conocen a Maradona (según el punto 3, donde son amigos directos o conocen a alguien que es amigo de él).
El predicado debe ser inversible.*/

medicoConProblemas(Medico) :-
    atiende(Medico, _),
    findall(Jugador, atiendeAConflictivo(Medico, Jugador), ListaJugadoresConflictivos),
    length(ListaJugadoresConflictivos, Cantidad),
    Cantidad > 3.

atiendeAConflictivo(Medico, Jugador) :-
    atiende(Medico, Jugador),
    esConflictivo(Jugador).

esConflictivo(Jugador) :- puedeSerSuspendido(Jugador).
esConflictivo(Jugador) :- conoce(Jugador, maradona).