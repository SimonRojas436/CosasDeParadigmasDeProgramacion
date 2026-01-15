/*WHO YOU GONNA CALL?*/
/*En épocas de crisis financiera, incluso los habitantes del mundo paranormal abandonan el plano físico en busca de
empleo, dejando montones de hogares dados vuelta y con sustancias pegajosas en lugares exóticos. Sin fantasmas, y ninguna
fuente de ingresos estable, los cazafantasmas (Peter, Egon, Ray y Winston) deciden cambiar de rumbo en una empresa de otro
calibre, la tenebrosa limpieza a domicilio.
  Sabemos cuáles son las herramientas requeridas para realizar una tarea de limpieza. Además, para las aspiradoras se
indica cuál es la potencia mínima requerida para la tarea en cuestión.*/

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).



/*Se pide resolver los siguientes requerimientos aprovechando las ideas del paradigma lógico, y asegurando que los predicados
principales sean completamente inversibles, a menos que se indique lo contrario:*/

/*PUNTO 1:
Agregar a la base de conocimientos la siguiente información:
    A. Egon tiene una aspiradora de 200 de potencia.
    B. Egon y Peter tienen un trapeador, Ray y Winston no.
    C. Sólo Winston tiene una varita de neutrones.
    D. Nadie tiene una bordeadora.*/

tiene(egon, aspiradora(200)).
%tiene(egon, varitaDeNeutrones).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).



/*PUNTO 2:
Definir un predicado que determine si un integrante satisface la necesidad de una herramienta requerida. Esto será
cierto si tiene dicha herramienta, teniendo en cuenta que si la herramienta requerida es una aspiradora, el integrante
debe tener una con potencia igual o superior a la requerida.
Nota: No se pretende que sea inversible respecto a la herramienta requerida.*/

satisfaceLaNecesidad(Integrante, Herramienta) :- tiene(Integrante, Herramienta).

satisfaceLaNecesidad(Integrante, aspiradora(PotenciaRequerida)) :-
    tiene(Integrante, aspiradora(Potencia)),
    Potencia >= PotenciaRequerida.



/*PUNTO 3:
Queremos saber si una persona puede realizar una tarea, que dependerá de las herramientas que tenga. Sabemos que:
    - Quien tenga una varita de neutrones puede hacer cualquier tarea, independientemente de qué herramientas requiera
      dicha tarea.
    - Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de todas las herramientas requeridas
      para dicha tarea.*/

puedeRealizar(Integrante, Tarea) :- 
    herramientasRequeridas(Tarea, _),
    tiene(Integrante, varitaDeNeutrones).

puedeRealizar(Integrante, Tarea) :-
    tiene(Integrante, _),
    herramientasRequeridas(Tarea, Herramientas),
    forall(member(Herramienta, Herramientas), satisfaceLaNecesidad(Integrante, Herramienta)).



/*PUNTO 4:
Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido (que son las tareas que pide).
Para ellos disponemos de la siguiente información en la base de conocimientos:
    - tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros cuadrados sobre los cuales hay
      que realizar esa tarea.
    - precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al cliente.
Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea, multiplicando el precio por
los metros cuadrados de la tarea.*/

% tareaPedida(Cliente, TareaPedida, CantMetros)
tareaPedida(simon, ordenarCuarto, 5).
tareaPedida(simon, cortarPasto, 9).
tareaPedida(simon, limpiarBanio, 3).
tareaPedida(dimitri, encerarPisos, 7).

% precio(Tarea, PrecioPorMetro)
precio(ordenarCuarto, 40).
precio(limpiarTecho, 120).
precio(cortarPasto, 80).
precio(limpiarBanio, 150).
precio(encerarPisos, 60).

precioACobrar(Cliente, Precio) :-
    tareaPedida(Cliente, _, _),
    findall(Precio, precioDeUnaTarea(Cliente, Precio), Precios),
    sum_list(Precios, Precio).

precioDeUnaTarea(Cliente, Precio) :-
    tareaPedida(Cliente, TareaPedida, CantMetros),
    precio(TareaPedida, PrecioPorMetro),
    Precio is CantMetros * PrecioPorMetro.



/*PUNTO 5:
Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente. Un integrante acepta el pedido cuando puede
realizar todas las tareas del pedido y además está dispuesto a aceptarlo. Sabemos que:
    - Ray sólo acepta pedidos que no incluyan limpiar techos.
    - Winston sólo acepta pedidos que paguen más de $500.
    - Egon está dispuesto a aceptar pedidos que no tengan tareas complejas.
    - Peter está dispuesto a aceptar cualquier pedido.
Decimos que una tarea es compleja si requiere más de dos herramientas. Además la limpieza de techos siempre es compleja.*/

aceptaElPedidoDe(Integrante, Cliente) :-
    puedeRealizarTodasLasTareasDelPedido(Integrante, Cliente),
    estaDispuestoAAceptarElPedido(Integrante, Cliente).

puedeRealizarTodasLasTareasDelPedido(Integrante, Cliente) :-
    puedeRealizar(Integrante, _),
    tareaPedida(Cliente, _, _),
    forall(tareaPedida(Cliente, Tarea, _), puedeRealizar(Integrante, Tarea)).

estaDispuestoAAceptarElPedido(ray, Cliente) :-
    tareaPedida(Cliente, _, _),
    not(tareaPedida(Cliente, limpiarTecho, _)).

estaDispuestoAAceptarElPedido(winston, Cliente) :-
    precioACobrar(Cliente, Precio),
    Precio > 500.

estaDispuestoAAceptarElPedido(egon, Cliente) :-
    tareaPedida(Cliente, Tarea, _),
    not(esCompleja(Tarea)).

estaDispuestoAAceptarElPedido(peter, Cliente) :- tareaPedida(Cliente, _, _).

esCompleja(limpiarTecho).

esCompleja(Tarea) :-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, CantHerramientas),
    CantHerramientas > 2.