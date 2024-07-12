/*Son tiempos difíciles y además de dar clases, los profesores de Paradigmas abrimos un kioskito. Para poder atenderlo
como se debe, establecimos un sistema de turnos donde cada persona se hace responsable. Por ejemplo:
    - Dodain atiende lunes, miércoles y viernes de 9 a 15.
    - Lucas atiende los martes de 10 a 20.
    - JuanC atiende los sábados y domingos de 18 a 22.
    - JuanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
    - LeoC atiende los lunes y los miércoles de 14 a 18.
    - Martu atiende los miércoles de 23 a 24.
Consideramos siempre la hora exacta, por ejemplo: 10, 14, 17. Está fuera del alcance del examen contemplar horarios
como 10:15 ó 17:30.*/



/*PUNTO 1: CALENTANDO MOTORES.
Definir la relación para asociar cada persona con el rango horario que cumple, e incorporar las siguientes cláusulas:
    - Vale atiende los mismos días y horarios que dodain y juanC.
    - Nadie hace el mismo horario que leoC.
    - Maiu está pensando si hace el horario de 0 a 8 los martes y miércoles.
En caso de no ser necesario hacer nada, explique qué concepto teórico está relacionado y justifique su respuesta.*/

atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabados, 18, 22).
atiende(juanC, domindos, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).
atiende(vale, Dia, HoraInicio, HoraFin) :- atiende(dodain, Dia, HoraInicio, HoraFin).
atiende(vale, Dia, HoraInicio, HoraFin) :- atiende(juanC, Dia, HoraInicio, HoraFin).



/*PUNTO 2: QUIEN ATIENDE EL KIOSKO...
Definir un predicado que permita relacionar un día y hora con una persona, en la que dicha persona atiende el kiosko.
Algunos ejemplos:
    - Si preguntamos quién atiende los lunes a las 14, son dodain, leoC y vale
    - Si preguntamos quién atiende los sábados a las 18, son juanC y vale
    - Si preguntamos si juanFdS atiende los jueves a las 11, nos debe decir que sí.
    - Si preguntamos qué días a las 10 atiende vale, nos debe decir los lunes, miércoles y viernes.
El predicado debe ser inversible para relacionar personas y días.*/

atiendeElKiosko(Persona, DiaEspecifico, HoraEspecifica) :-
    atiende(Persona, DiaEspecifico, HoraInicio, HoraFin),
    between(HoraInicio, HoraFin, HoraEspecifica).



/*PUNTO 3: FOREVER ALONE.
Definir un predicado que permita saber si una persona en un día y horario determinado está atendiendo ella sola. En
este predicado debe utilizar 'not/1', y debe ser inversible para relacionar personas. Ejemplos:
    - Si preguntamos quiénes están forever alone el martes a las 19, lucas es un individuo que satisface esa relación.
    - Si preguntamos quiénes están forever alone el jueves a las 10, juanFdS es una respuesta posible.
    - Si preguntamos si martu está forever alone el miércoles a las 22, nos debe decir que no (martu hace un turno diferente).
    - Martu sí está forever alone el miércoles a las 23.
    - El lunes a las 10 dodain no está forever alone, porque vale también está.*/

foreverAlone(Persona, DiaEspecifico, HoraEspecifica) :-
    atiendeElKiosko(Persona, DiaEspecifico, HoraEspecifica),
    not((atiendeElKiosko(OtraPersona, DiaEspecifico, HoraEspecifica), Persona \= OtraPersona)).



/*PUNTO 4: POSIBILIDADES DE ATENCIÓN.
Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. Por ejemplo,
si preguntamos por el miércoles, tiene que darnos esta combinatoria:
    - Nadie.
    - Dodain solo.
    - Dodain y leoC.
    - Dodain, vale, martu y leoC.
    - Vale y martu.
    - Etc.
Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona atienda ese día
(no puede aparecer lucas, por ejemplo, porque no atiende el miércoles).
PUNTO EXTRA: indique qué conceptos en conjunto permiten resolver este requerimientos.*/

posibilidadesDeAtencion(Dia, Posibilidad) :-
    findall(Persona, atiende(Persona, Dia, _, _), PersonasQueAtienden),
    posibilidades(PersonasQueAtienden, Posibilidad).

posibilidades([], []).
posibilidades([Persona|Personas], [Persona|Posibilidades]) :- posibilidades(Personas, Posibilidades).
posibilidades([_|Personas], Posibilidades) :- posibilidades(Personas, Posibilidades).



/*PUNTO 5: VENTAS / SUERTUDAS.
En el kiosko tenemos por el momento tres ventas posibles:
    - Golosinas, en cuyo caso registramos el valor en plata.
    - Cigarrillos, de los cuales registramos todas las marcas de cigarrillos que se vendieron.
    - Bebidas, en cuyo caso registramos si son alcohólicas y la cantidad.
Queremos agregar las siguientes cláusulas:
    - Dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $1200, cigarrillos Jockey, golosinas por $50.
    - Dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $10.
    - Martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $1000, cigarrillos Chesterfield, Colorado y Parisiennes.
    - Lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $600.
    - Lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.
Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió, la primera
venta que hizo fue importante. Una venta es importante:
    - En el caso de las golosinas, si supera los $ 100.
    - En el caso de los cigarrillos, si tiene más de dos marcas.
    - En el caso de las bebidas, si son alcohólicas o son más de 5.
El predicado debe ser inversible: martu y dodain son personas suertudas.*/

venta(dodain, fecha(lunes, 10, agosto), [golosinas(1200), cigarrillos([jockey]), golosinas(50)]).
venta(dodain, fecha(miercoles, 12, agosto), [bebidas(8, alcoholicas), bebidas(1, noAlcoholicas), golosinas(10)]).
venta(martu, fecha(miercoles, 12, agosto), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, fecha(martes, 11, agosto), [golosinas(600)]).
venta(lucas, fecha(martes, 18, agosto), [bebidas(2, noAlcoholicas), cigarrillos([derby])]).

vendedor(Persona) :- venta(Persona, _, _).

vendedorSuertudo(Persona) :-
    vendedor(Persona),
    forall(venta(Persona, _, [Venta|_]), esImportante(Venta)).

esImportante(golosinas(Valor)) :- Valor > 100.
esImportante(cigarrillos(Marcas)) :- length(Marcas, Cant), Cant > 2.
esImportante(bebidas(_, alcoholicas)).
esImportante(bebidas(Cant, _)) :- Cant > 5.