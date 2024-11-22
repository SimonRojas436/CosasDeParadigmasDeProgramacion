/*PUNTO 1: ACCIONES
Conocemos el nombre de cada jugador y las acciones que fueron pasando en el partido. Las cuales son:
    - El Dibu realizó una atajada en el minuto 122. También, en la tanda de penales atajó 2 de ellos.
    - Messi metió 2 goles, uno en el minuto 108 de jugada y otro en el minuto 23 de penal. A su vez, también metió el primer penal de la tanda.
    - Montiel metió el último penal de la tanda de penales.
Se pide modelar la base de conocimientos con las acciones y quienes las realizaron.*/

jugador(elDibu).
jugador(messi).
jugador(montiel).

accion(elDibu, atajada(122)).
accion(elDibu, atajadaPenal(2)).
accion(messi, gol(108)).
accion(messi, gol(23)).
accion(messi, penal(1)).
accion(montiel, penal(5)).



/*PUNTO 2: PUNTAJES DE LAS ACCIONES
Queremos saber cuantos puntos suma cada acción. Los cuales son calculados de la siguiente forma:
    - Para las atajadas tanda de penales, suman 15 * la cantidad que se hayan atajado.
    - Para las otras atajadas, el puntaje se calcula como el minuto en el que ocurrió más 10.
    - Para los goles, se calcula como el minuto en el que se metió más 20.
    - Por último, para los penales que se metieron, en caso de que sea el primero suma  45 puntos mientras que si es el último suma 80 puntos.
Se pide modelar la base de conocimientos con los puntajes de cada acción. También, queremos saber cuantos puntos suma cada jugador.*/

puntaje(atajadaPenal(Cantidad), Puntaje) :- Puntaje is Cantidad * 15.
puntaje(atajada(Minuto), Puntaje) :- Puntaje is Minuto + 10.
puntaje(gol(Minuto), Puntaje) :- Puntaje is Minuto + 20.
puntaje(penal(1), 45).
puntaje(penal(5), 80).

puntajeJugador(Jugador, Puntos) :-
    jugador(Jugador),
    findall(Puntaje, puntajeAccion(Jugador, Puntaje), Puntajes),
    sum_list(Puntajes, Puntos).

puntajeAccion(Jugador, Puntaje) :-
    accion(Jugador, Accion),
    puntaje(Accion, Puntaje).



/*PUNTO 3: SUPERFICIE TOTAL DEL EQUIPO
Dada una lista de jugadores, queremos saber cuanto puntos sumaron todos.*/

puntosEquipo(Equipo, Puntos) :-
    findall(PuntosJugador, (member(Jugador, Equipo), puntajeJugador(Jugador, PuntosJugador)), Puntajes),
    sum_list(Puntajes, Puntos).



/*PUNTO 4: SUPERFICIE TOTAL
Calcular la cantidad total de puntos de todos los jugadores*/
todosLosPuntos(Puntos) :-
    findall(Punto, puntajeJugador(_, Punto), Puntajes),
    sum_list(Puntajes, Puntos).