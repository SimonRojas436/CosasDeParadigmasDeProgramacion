/*PUNTO 1*/
jugador(ana).
jugador(beto).
jugador(carola).
jugador(dimitri).
%jugador(elsa).

civilizacion(romanos).
civilizacion(incas).

tecnologia(herreria).
tecnologia(molino).
tecnologia(emplumado).
tecnologia(forja).
tecnologia(laminas).
tecnologia(collera).
tecnologia(punzon).
tecnologia(fundicion).
tecnologia(malla).
tecnologia(arado).
tecnologia(horno).
tecnologia(placas).

juegaCon(ana, romanos).
juegaCon(beto, incas).
juegaCon(dimitri, romanos).
juegaCon(dimitri, romanos).

desarrolla(ana, herreria).
desarrolla(ana, forja).
desarrolla(ana, emplumado).
desarrolla(ana, laminas).
desarrolla(beto, herreria).
desarrolla(beto, forja).
desarrolla(beto, fundicion).
desarrolla(carola, herreria).
desarrolla(dimitri, herreria).
desarrolla(dimitri, fundicion).



/*PUNTO 2*/
esExpertoEnMetales(Jugador) :-
    desarrolla(Jugador, herreria),
    desarrolla(Jugador, forja),
    desarrolla(Jugador, fundicion).

esExpertoEnMetales(Jugador) :-
    desarrolla(Jugador, herreria),
    desarrolla(Jugador, forja),
    juegaCon(Jugador, romanos).



/*PUNTO 3*/
esPopular(Civilizacion) :-
    juegaCon(Jugador, Civilizacion),
    juegaCon(OtroJugador, Civilizacion),
    Jugador \= OtroJugador.



/*PUNTO 4*/
tieneAlcanceGlobal(Tecnologia) :-
    tecnologia(Tecnologia),
    forall(jugador(Jugador), desarrolla(Jugador, Tecnologia)).



/*PUNTO 5*/
esLider(Civilizacion) :-
    civilizacion(Civilizacion),
    forall(tecnologia(Tecnologia), (juegaCon(Jugador, Civilizacion), desarrolla(Jugador, Tecnologia))).


/*PUNTO 6*/
tieneUn(ana, jinete(caballo)).
tieneUn(ana, piquero(conEscudo, 1)).
tieneUn(ana, piquero(sinEscudo, 2)).
tieneUn(beto, campeon(100)).
tieneUn(beto, campeon(80)).
tieneUn(beto, piquero(conEscudo, 1)).
tieneUn(beto, jinete(caballo)).
tieneUn(carola, piquero(sinEscudo, 3)).
tieneUn(carola, piquero(conEscudo, 2)).



/*PUNTO 7*/
vida(jinete(camello), 80).
vida(jinete(caballo), 90).
vida(campeon(Vida), Vida).
vida(piquero(sinEscudo, 1), 50).
vida(piquero(sinEscudo, 2), 65).
vida(piquero(sinEscudo, 3), 70).
vida(piquero(conEscudo, Nivel), Vida) :- vida(piquero(sinEscudo, Nivel), VidaSinEscudo), (Vida is VidaSinEscudo * 1.10).

conMasVida(Unidad, Jugador) :-
    tieneUn(Jugador, Unidad),
    not(forall(tieneUn(Jugador, Unidad), (tieneUn(Jugador, OtraUnidad), (Unidad \= OtraUnidad), vida(OtraUnidad, OtraVida), vida(Unidad, Vida), (OtraVida > Vida)))).



/*Punto 8*/
ventajaSobre(jinete(_), campeon(_)).
ventajaSobre(campeon(_), piquero(_, _)).
ventajaSobre(piquero(_, _), jinete(_)).
ventajaSobre(jinete(camello), jinete(caballo)).

leGanaA(Unidad, OtraUnidad) :- ventajaSobre(Unidad, OtraUnidad).

leGanaA(Unidad, OtraUnidad) :-
    not(ventajaSobre(OtraUnidad, Unidad)),
    vida(Unidad, Vida),
    vida(OtraUnidad, OtraVida),
    Vida > OtraVida.



/*PUNTO 9*/
sobreviveAsedio(Jugador) :-
    jugador(Jugador),
    cantidadDe(Cant1, piquero(conEscudo, _), Jugador),
    cantidadDe(Cant2, piquero(sinEscudo, _), Jugador),
    Cant1 > Cant2.

cantidadDe(Cant, Unidad, Jugador) :-
    findall(Unidad, tieneUn(Jugador, Unidad), Lista),
    length(Lista, Cant).



/*PUNTO 10*/
depende(punzon, emplumado).
depende(emplumado, herreria).

depende(horno, fundicion).
depende(fundicion, forja).
depende(forja, herreria).

depende(placas, malla).
depende(malla, laminas).
depende(laminas, herreria).

depende(arado, collera).
depende(collera, molino).


puedeDesarrollar(Jugador, Tecnologia) :-
    jugador(Jugador),
    tecnologia(Tecnologia),
    not(desarrolla(Jugador, Tecnologia)),
    forall(dependenciaDI(Tecnologia, Dependencia), desarrolla(Jugador, Dependencia)).

dependenciaDI(Tecnologia, Dependencia) :- depende(Tecnologia, Dependencia).

dependenciaDI(Tecnologia, Dependencia) :-
    depende(Tecnologia, DependenciaIntermedia),
    dependenciaDI(DependenciaIntermedia, Dependencia).



/*PUNTO 11 - A CHEQUEAR
ordenValido(Jugador, Orden) :-
    jugador(Jugador),
    findall(Tecnologia, (desarrolla(Jugador, Tecnologia), depende(Dependencia, Tecnologia), permiteDesarrollar(Tecnologia, Dependencia), tecnologia(Tecnologia)), Orden).

permiteDesarrollar(Base, Tecnologia) :- depende(Tecnologia, Base).

permiteDesarrollar(Base, Tecnologia) :-
    depende(Tecnologia, Intermedio),
    permiteDesarrollar(Base, Intermedio).*/


/*
PUNTO 12
pierdeContra(Jugador, EjercitoAtacante) :-
    findall(Unidad, tieneUn(Jugador, Unidad), EjercitoDefensor),
    xxx(EjercitoDefensor, Ejercito, EjercitoAtacante).

xxx([], [], EjercitoAtacante).

xxx([UnidadDefensora|RestoDefensoras], [UnidadAtacante|RestoAtacantes], EjercitoAtacante) :-
    member(UnidadAtacante, Ejercito),
    leGanaA(UnidadAtacante, UnidadDefensora),
    append(UnidadAtacante, [], EjercitoAtacante),
    xxx(RestoDefensoras, RestoAtacantes, EjercitoAtacante).*/