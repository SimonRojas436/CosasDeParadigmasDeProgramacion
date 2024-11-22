/*Estamos armando un programs de proOlog para hacer mas fácil el manejo de un prode en la fase de eliminación directo
del mundial. Un Prode (pronósticos deportivos) es un juego en el que se intenta adivinar los resultados de partidos.
Los jugadores del prode dan sus pronósticos de cómo sale cada partido y si el pronóstico fue acertado suma puntos.
Al fina1 del prode aquel jugador que haya sumado mas puntos gana.
Contamos con los siguientes hechos que representan los resultados reales de los partidos:*/
% resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais)
resultado(paises_bajos, 3, estados_unidos, 1).                      % Paises bajos 3 - 1 Estados unidos
resultado(australia, 1, argentina, 2).                              % Australia 1 - 2 Argentina
resultado(polonia, 3, francia, 1).
resultado(inglaterra, 3, senegal, 0).
/*Y con hechos de esta forma que dicen qué pronosticó tiene cada jugador del prode:*/
% pronostico(Jugador, Pronostico)
pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).         % 200 puntos
pronostico(juan, gano(argentina, australia, 3, 0)).                 % 100 puntos
pronostico(juan, empataron(inglaterra, senegal, 0)).                % 0 puntos
pronostico(gus, gano(estados_unidos, paises_bajos, 1, 0)).          % 0 puntos
pronostico(gus, gano(japon, croacia, 2, 0)).                        % 0 puntos (aun no jugaron)             
pronostico(lucas, gano(paises_bajos, estados_unidos, 3, 1)).        % 200 puntos
pronostico(lucas, gano(argentina, australia, 2, 0)).                % 100 puntos
pronostico(lucas, gano(croacia, japon, 1, 0)).                      % 0 puntos (aun no jugaron)
% Puntos totales juan: 300
% Puntos totales gus: 0
% Puntos totales lucas: 300

/*PUNTO 1:
Implemente el predicado 'jugaron/3', que relaciona dos paises que hayan jugado un partido y la diferencia de goles
entre ambos.*/

resultadoSimetrico(Pais, Goles, OtroPais, OtrosGoles) :- resultado(Pais, Goles, OtroPais, OtrosGoles).
resultadoSimetrico(Pais, Goles, OtroPais, OtrosGoles) :- resultado(OtroPais, OtrosGoles, Pais, Goles).

jugaron(Pais, OtroPais, Diferencia) :-
    resultadoSimetrico(Pais, Goles, OtroPais, OtrosGoles),
    Diferencia is Goles - OtrosGoles.



/*PUNTO 2:
Implemente el predicado 'gana/2', donde un país le ganó a otro si ambos jugaron y el ganador metió mśs gales que el otro.*/

gano(PaisGanador, PaisPerdedor) :-
    jugaron(PaisGanador, PaisPerdedor, Diferencia),
    Diferencia > 0.



/*PUNTO 3:
Implemente el predicado 'puntosPronostico/2', donde cada pronóstico al que se apuesta en el prode vale una cierta cantidad
de puntos dependiendo de qué tan acertado fue respecto del resultado del partido. Si hay un resu1tado para el partido y:
    - El pronóstico le pegó a el ganador o a si fue empate y a la cantidad de goles de ambos, vale 200 puntos.
    - El pronóstico le pegó a el ganador o a si fue empate pero no a la cantidad de goles, vale 100 puntos.
    - No le pegó al ganador o a si fue empate, vale 0 puntos.*/

puntosPronostico(Pronostico, PuntosPronostico) :-
    hayResultadoParaPartido(Pronostico),
    calcularPuntos(Pronostico, PuntosPronostico).

hayResultadoParaPartido(gano(Pais, OtroPais, _, _)) :- jugaron(Pais, OtroPais, _).
hayResultadoParaPartido(empataron(Pais, OtroPais, _)) :- jugaron(Pais, OtroPais, _).

calcularPuntos(Pronostico, 200) :-
    lePegoAlGanadorOEmpate(Pronostico),
    lePegoCantGoles(Pronostico).

calcularPuntos(Pronostico, 100) :-
    lePegoAlGanadorOEmpate(Pronostico),
    not(lePegoCantGoles(Pronostico)).

calcularPuntos(Pronostico, 0) :- not(lePegoAlGanadorOEmpate(Pronostico)).

lePegoAlGanadorOEmpate(gano(Pais, OtroPais, _, _)) :- gano(Pais, OtroPais).
lePegoAlGanadorOEmpate(empataron(Pais, OtroPais, _, _)) :-
    jugaron(Pais, OtroPais, Diferencia),
    Diferencia = 0.

lePegoCantGoles(gano(Pais, OtroPais, GolesPais, GolesOtroPais)) :- resultadoSimetrico(Pais, GolesPais, OtroPais, GolesOtroPais).
lePegoCantGoles(empataron(Pais, OtroPais, CantGoles)) :- resultadoSimetrico(Pais, CantGoles, OtroPais, CantGoles).



/*PUNTO 3:
Implemente el predicado 'invicto/1', donde un jugador del prode esta invicto si sacó al menos 100 puntos en cada pronóstico
que hizo. Los pronósticos de partidos que aún no se jugaron no deben tenerse en cuenta.*/

invicto(Jugador) :-
    pronostico(Jugador, _),
    forall((pronostico(Jugador, Pronostico), hayResultadoParaPartido(Pronostico)), sacoAlMenosCienPuntos(Pronostico)).

sacoAlMenosCienPuntos(Pronostico) :-
    puntosPronostico(Pronostico, PuntosPronostico),
    PuntosPronostico >= 100.



/*PUNTO 4:
Implemente el pedicado 'puntaje/2', que relaciona a un jugador con el total de puntos que hizo para todos sus pronosticos.*/

puntaje(Jugador, TotalPuntos) :-
    pronostico(Jugador, _),
    findall(Puntos, invictoHastaAhora(Jugador, Puntos), ListaPuntos),
    sum_list(ListaPuntos, TotalPuntos).

invictoHastaAhora(Jugador, Puntos) :-
    pronostico(Jugador, Pronostico),
    puntosPronostico(Pronostico, Puntos).



/*PUNTO 5:
Implemente el predicado 'favorito/1', donde un país es favonto si todos los pronósticos que se hicieron sobre ese pais
lo ponen como ganador o si todos lo partidos que jugó los ganó por goleada (diferencia de al menos 3 goles).*/

estaEnElPronostico(Pais, gano(Pais, OtroPais, Goles, OtrosGoles)) :- pronostico(_, gano(Pais, OtroPais, Goles, OtrosGoles)).
estaEnElPronostico(Pais, gano(Pais, OtroPais, Goles, OtrosGoles)) :- pronostico(_, gano(OtroPais, Pais, OtrosGoles, Goles)).
estaEnElPronostico(Pais, empataron(Pais, OtroPais, CantGoles)) :- pronostico(_, empataron(Pais, OtroPais, CantGoles)).
estaEnElPronostico(Pais, empataron(Pais, OtroPais, CantGoles)) :- pronostico(_, empataron(OtroPais, Pais, CantGoles)).

favorito(Pais) :-
    estaEnElPronostico(Pais, _),
    forall(estaEnElPronostico(Pais, Pronostico), loDaGanador(Pais, Pronostico)).

favorito(Pais) :-
    resultadoSimetrico(Pais, _, _, _),
    forall(jugaron(Pais, _, Diferencia), Diferencia >= 3).

loDaGanador(Pais, gano(Pais, _, _, _)).




































