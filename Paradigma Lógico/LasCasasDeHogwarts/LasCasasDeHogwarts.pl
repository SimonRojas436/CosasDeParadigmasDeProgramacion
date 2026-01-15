/*En Hogwarts, el colegio de magia y hechicería, hay 4 casas en las cuales los nuevos alumnos se distribuyen ni bien
ingresan. Cada año estas casas compiten entre ellas para consagrarse la ganadora de la copa.*/

/*PARTE 1: SOMBRERO SELECCIONARDOR.
Para determinar en qué casa queda una persona cuando ingresa a Hogwarts, el Sombrero Seleccionador tiene en cuenta el
carácter de la persona, lo que prefiere y en algunos casos su status de sangre.
    Tenemos que registrar en nuestra base de conocimientos qué características tienen los distintos magos que ingresaron
a Hogwarts, el status de sangre que tiene cada mago y en qué casa odiaría quedar. Actualmente sabemos que:
    - Harry es sangre mestiza, y se caracteriza por ser corajudo, amistoso, orgulloso e inteligente. Odiaría que el
      sombrero lo mande a Slytherin.
    - Draco es sangre pura, y se caracteriza por ser inteligente y orgulloso, pero no es corajudo ni amistoso. Odiaría
      que el sombrero lo mande a Hufflepuff.
    - Hermione es sangre impura, y se caracteriza por ser inteligente, orgullosa y responsable. No hay ninguna casa a la
      que odiaría ir.*/

/*Además nos interesa saber cuáles son las características principales que el sombrero tiene en cuenta para elegir la
casa más apropiada:
    - Para Gryffindor, lo más importante es tener coraje.
    - Para Slytherin, lo más importante es el orgullo y la inteligencia.
    - Para Ravenclaw, lo más importante es la inteligencia y la responsabilidad.
    - Para Hufflepuff, lo más importante es ser amistoso.*/

/*PUNTO 1:
Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso
de Slytherin, que no permite entrar a magos de sangre impura.*/

casa(gryffindor).
casa(ravenclaw).
casa(hufflepuff).
casa(slytherin).

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).

mago(Mago) :- sangre(Mago, _).

permiteEntrar(Casa, Mago) :-
    casa(Casa),
    mago(Mago),
    Casa \= slytherin.

permiteEntrar(slytherin, Mago) :-
    sangre(Mago, TipoDeSangre),
    TipoDeSangre \= impura.



/*PUNTO 2:
Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus características
incluyen todo lo que se busca para los integrantes de esa casa, independientemente de si la casa le permite la entrada.*/

/*PRIMERA FORMA:
caracteristicas(harry, [coraje, amistad, orgullo, inteligencia]).
caracteristicas(draco, [inteligencia, orgullo]).
caracteristicas(hermione, [inteligencia, orgullo, responsabilidad]).

esImportanteTener(gryffindor, coraje).
esImportanteTener(slytherin, orgullo).
esImportanteTener(slytherin, inteligencia).
esImportanteTener(ravenclaw, inteligencia).
esImportanteTener(ravenclaw, responsabilidad).
esImportanteTener(hufflepuff, amistoso).

tieneCaracterApropiado(Mago, Casa) :-
    mago(Mago),
    casa(Casa),
    forall(esImportanteTener(Casa, Caracteristica), laTieneUn(Caracteristica, Mago)).

laTieneUn(Mago, Caracteristica) :-
    caracteristicas(Mago, Caracteristicas),
    member(Caracteristica, Caracteristicas).*/

/*SEGUNDA FORMA:*/
caracteristica(harry, coraje).
caracteristica(harry, amistad).
caracteristica(harry, orgullo).
caracteristica(harry, inteligencia).
caracteristica(draco, inteligencia).
caracteristica(draco, orgullo).
caracteristica(hermione, inteligencia).
caracteristica(hermione, orgullo).
caracteristica(hermione, responsabilidad).

esImportanteTener(gryffindor, coraje).
esImportanteTener(slytherin, orgullo).
esImportanteTener(slytherin, inteligencia).
esImportanteTener(ravenclaw, inteligencia).
esImportanteTener(ravenclaw, responsabilidad).
esImportanteTener(hufflepuff, amistad).

tieneCaracterApropiado(Mago, Casa) :-
    mago(Mago),
    casa(Casa),
    forall(esImportanteTener(Casa, Caracteristica), caracteristica(Mago, Caracteristica)).



/*PUNTO 3:
Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa,
la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. Además Hermione puede quedar seleccionada
en Gryffindor, porque al parecer encontró una forma de hackear al sombrero.*/
odia(harry, slytherin).
odia(draco, hufflepuff).

puedeIrA(Mago, Casa) :-
    %el mago debe tener el caracter adecuado.
    tieneCaracterApropiado(Mago, Casa),
    %la casa permite la entradda del mago
    permiteEntrar(Casa, Mago),
    %el mago no odiaria ir a dicha casa
    not(odia(Mago, Casa)).

puedeIrA(hermione, gryffindor).

/*PUNTO 4:
Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se caracterizan por ser
amistosos y cada uno podría estar en la misma casa que el siguiente. No hace falta que sea inversible, se consultará
de forma individual.*/

/*PRIMERA FORMA:*/
cadenaDeAmistades(ListaMagos) :-
    sonTodosAmistosos(ListaMagos),
    cadenaDeCasas(ListaMagos).

sonTodosAmistosos(ListaMagos) :-
    forall(member(Mago, ListaMagos), caracteristica(Mago, amistad)).

cadenaDeCasas([]).
cadenaDeCasas([_]).
cadenaDeCasas([Mago, OtroMago|RestoMagos]) :-
    puedeIrA(OtroMago, OtraCasa),
    puedeIrA(Mago, OtraCasa),
    cadenaDeCasas([OtroMago|RestoMagos]).

/*SEGUNDA FORMA:
cadenaDeAmistades(ListaMagos) :-
    forall(consecutivos(Mago1, Mago2, ListaMagos), puedenQuedarEnLaMismaCasa(Mago1, Mago2)).

consecutivos(Anterior, Siguiente, ListaMagos) :-
    nth1(IndiceAnterior, ListaMagos, Anterior),
    IndiceSiguiente is IndiceAnterior + 1,
    nth1(IndiceSiguiente, ListaMagos, Siguiente).

puedenQuedarEnLaMismaCasa(Mago1, Mago2) :-
    puedeIrA(Mago2, OtraCasa),
    puedeIrA(Mago1, OtraCasa),
    Mago1 \= Mago2.*/



/*PARTE 2: LAS COPAS DE LAS CASAS...
A lo largo del año los alumnos pueden ganar o perder puntos para su casa en base a las buenas y malas acciones realizadas,
y cuando termina el año se anuncia el ganador de la copa. Sobre las acciones que impactan al puntaje actualmente tenemos
la siguiente información:
    - Malas acciones: son andar de noche fuera de la cama (que resta 50 puntos) o ir a lugares prohibidos. La cantidad
      de puntos que se resta por ir a un lugar prohibido se indicará para cada lugar. Ir a un lugar que no está prohibido no afecta al puntaje.
    - Buenas acciones: son reconocidas por los profesores y prefectos individualmente y el puntaje se indicará para cada
      acción premiada.
Necesitamos registrar las distintas acciones que hicieron los alumnos de Hogwarts durante el año. Sabemos que:
    - Harry anduvo fuera de cama.
    - Hermione fue al tercer piso y a la sección restringida de la biblioteca.
    - Harry fue al bosque y al tercer piso.
    - Draco fue a las mazmorras.
    - A Ron le dieron 50 puntos por su buena acción de ganar una partida de ajedrez mágico.
    - A Hermione le dieron 50 puntos por usar su intelecto para salvar a sus amigos de una muerte horrible.
    - A Harry le dieron 60 puntos por ganarle a Voldemort.
También sabemos que los siguientes lugares están prohibidos:
    - El bosque, que resta 50 puntos.
    - La sección restringida de la biblioteca, que resta 10 puntos.
    - El tercer piso, que resta 75 puntos.
También sabemos en qué casa quedó seleccionado efectivamente cada alumno mediante el predicado esDe/2 que relaciona a
la persona con su casa, por ejemplo:
    esDe(hermione, gryffindor).
    esDe(ron, gryffindor).
    esDe(harry, gryffindor).
    esDe(draco, slytherin).
    esDe(luna, ravenclaw).
Se pide incorporar a la base de conocimiento la información sobre las acciones realizadas y agregar la siguiente lógica
a nuestro programa:*/

/*PUNTO 5 - A:
Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera una
mala acción (que son aquellas que provocan un puntaje negativo).*/

hizo(harry, andarFueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, irA(seccionRestringidaBiblioteca)).
hizo(harry, irA(bosque)).
hizo(harry, irA(tercerPiso)).
hizo(draco, irA(mazmorras)).
hizo(ron, buenaAccion(ganarPartidaDeAjedrez, 50)).
hizo(hermione, buenaAccion(salvarASusAmigosDeMorir, 50)).
hizo(harry, buenaAccion(matarVoldemort, 60)).

/*SE PUEDE GENERALIZAR...
puntaje(irA(bosque), -50).
puntaje(irA(seccionRestringidaBiblioteca), -10).
puntaje(irA(tercerPiso), -75).
*/

puntaje(irA(Lugar), Puntaje) :- lugarProhibido(Lugar, Puntaje), Puntaje < 0.
puntaje(andarFueraDeCama, -50).
puntaje(buenaAccion(_, Puntaje), Puntaje).

lugarProhibido(bosque, -50).
lugarProhibido(seccionRestringidaBiblioteca, -10).
lugarProhibido(tercerPiso, -75).

puntajeQueGenera(Accion, Puntaje) :- puntaje(Accion, Puntaje).

esBuenAlumno(Mago) :-
    hizoAlgunaAccion(Mago),
    not(hizoUnaMalaAccion(Mago)).

hizoAlgunaAccion(Mago) :- hizo(Mago, _).

hizoUnaMalaAccion(Mago) :-
    hizo(Mago, Accion),
    puntajeQueGenera(Accion, Puntaje),
    Puntaje < 0.



/*PUNTO 5 - B:
Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.*/

esRecurrente(Accion) :-
    hizo(Mago, Accion),
    hizo(OtroMago, Accion),
    Mago \= OtroMago.



/*PUNTO 6:
Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.*/

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).


/*PRIMERA FORMA:*/
puntajeTotal(Casa, PuntajeTotal) :-
    esDe(_, Casa),
    findall(Puntaje, (esDe(Mago, Casa), puntajeMago(Mago, _, Puntaje)), ListaPuntos),
    sum_list(ListaPuntos, PuntajeTotal).

puntajeMago(Mago, Accion, Puntaje) :-
    hizo(Mago, Accion),
    puntajeQueGenera(Accion, Puntaje).

/*SEGUNDA FORMA:
puntajeTotalCasa(Casa, PuntajeTotal) :-
    esDe(_, Casa),
    findall(PuntajeTotalMago, (esDe(Mago, Casa), puntajeTotalMago(Mago, PuntajeTotalMago)), ListaPuntajesMagos),
    sum_list(ListaPuntajesMagos, PuntajeTotal).

puntajeTotalMago(Mago, PuntajeTotalMago) :-
    esDe(Mago, _),
    findall(Puntos, (hizo(Mago, Accion), puntajeQueGenera(Accion, Puntos)), ListaPuntajesMago),
    sum_list(ListaPuntajesMago, PuntajeTotalMago).*/



/*PUNTO 7:
Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor de
puntos que todas las otras.*/

casaGanadora(Casa) :-
    puntajeTotal(Casa, PuntajeTotalCasa),
    forall((puntajeTotal(OtraCasa, PuntajeTotalOtraCasa), (Casa \= OtraCasa)), PuntajeTotalCasa >= PuntajeTotalOtraCasa).