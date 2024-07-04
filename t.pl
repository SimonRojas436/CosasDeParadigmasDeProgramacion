/*PUNTO 1*/
/*Jugadores y la civilización con la que juegan*/
jugador(ana, romanos).
jugador(beto, incas).
jugador(carola, romanos).
jugador(dimitri, romanos).
/*Jugadores y tecnologias desarrolladas*/
tecnologiaDes(ana, herreria).
tecnologiaDes(ana, forja).
tecnologiaDes(ana, emplumado).
tecnologiaDes(ana, laminas).
tecnologiaDes(beto, herreria).
tecnologiaDes(beto, forja).
tecnologiaDes(beto, fundicion).
tecnologiaDes(carola, herreria).
tecnologiaDes(dimitri, herreria).
tecnologiaDes(dimitri, fundicion).


/*PUNTO 2*/
expertoEnMetales(Jugador) :-
    jugador(Jugador, _),
    tecnologiaDes(Jugador, herreria),
    tecnologiaDes(Jugador, forja),
    tecnologiaDes(Jugador, fundicion).

expertoEnMetales(Jugador) :-
    jugador(Jugador, romanos),
    tecnologiaDes(Jugador, herreria),
    tecnologiaDes(Jugador, forja).


/*PUNTO 3*/
civilizacionPopular(Civilizacion) :-
    jugador(Jugador, Civilizacion),
    jugador(OtroJugador, Civilizacion),
    Jugador \= OtroJugador.


/*PUNTO 4*/
tecnologiaGlobal(Tecnologia) :-
    tecnologiaDes(_, Tecnologia),
    forall(jugador(Jugador, _), tecnologiaDes(Jugador, Tecnologia)).


/*PUNTO 5*/
civilizacionLider(Civilizacion) :-
    jugador(_, Civilizacion),
    forall(tecnologiaDes(_, Tecnologia), (jugador(Jugador, Civilizacion), tecnologiaDes(Jugador, Tecnologia))).


/*PUNTO 6*/
unidad(campeon).
unidad(jinete).
unidad(piqueros).

unidadJugador(ana, unJinete(caballo)).
unidadJugador(ana, unPiqueroConEscudo(1)).
unidadJugador(ana, unPiqueroSinEscudo(2)).
unidadJugador(beto, unCampeon(100)).
unidadJugador(beto, unCampeon(80)).
unidadJugador(beto, unPiqueroConEscudo(1)).
unidadJugador(beto, unJinete(camello)).
unidadJugador(carola, unPiqueroSinEscudo(3)).
unidadJugador(carola, unPiqueroConEscudo(2)).


/*PUNTO 7*/
vidaUnidad(unJinete(camello), 80).
vidaUnidad(unJinete(caballo), 90).
vidaUnidad(unPiqueroSinEscudo(1), 50).
vidaUnidad(unPiqueroSinEscudo(2), 65).
vidaUnidad(unPiqueroSinEscudo(3), 70).
vidaUnidad(unCampeon(Vida), Vida).
vidaUnidad(unPiqueroConEscudo(1), Vida) :- Vida is 50 * 1.10.
vidaUnidad(unPiqueroConEscudo(2), Vida) :- Vida is 65 * 1.10.
vidaUnidad(unPiqueroConEscudo(3), Vida) :- Vida is 70 * 1.10.

unidadConMasVida(Jugador, Unidad) :-
    unidadJugador(Jugador, Unidad),
    vidaUnidad(Unidad, Vida),
    not((unidadJugador(Jugador, OtraUnidad), Unidad \= OtraUnidad, vidaUnidad(OtraUnidad, OtraVida), OtraVida > Vida)).


/*PUNTO 8 - DEFECTUOSO*/
ventaja(unJinete(_), unCampeon(_)).
ventaja(unCampeon(_), unPiqueroConEscudo(_)).
ventaja(unCampeon(_), unPiqueroSinEscudo(_)).
ventaja(unPiqueroConEscudo(_), unJinete(_)).
ventaja(unPiqueroSinEscudo(_), unJinete(_)).
ventaja(unJinete(camello), unJinete(caballo)).

leGanaA(Unidad, OtraUnidad) :- ventaja(Unidad, OtraUnidad).
leGanaA(Unidad, OtraUnidad) :-
    vidaUnidad(Unidad, Vida),
    vidaUnidad(OtraUnidad, OtraVida),
    Vida > OtraVida.


/*PUNTO 9*/
sobreviveAsedio(Jugador) :-
    jugador(Jugador, _),
    findall(unPiqueroConEscudo(_), unidadJugador(Jugador, unPiqueroConEscudo(_)), ConEscudo),
    findall(unPiqueroSinEscudo(_), unidadJugador(Jugador, unPiqueroSinEscudo(_)), SinEscudo),
    (length(ConEscudo, Cant1), length(SinEscudo, Cant2), Cant1 > Cant2).


/*Punto 10*/
depende(punzon, emplumado).
depende(emplumado, herreria).

depende(horno, fundicion).
depende(fundicion, forja).
depende(forja, herreria).

depende(placas, malla)
depende(malla, laminas).
depende(laminas, herreria).

depende(arado, collera).
depende(collera, molino).








