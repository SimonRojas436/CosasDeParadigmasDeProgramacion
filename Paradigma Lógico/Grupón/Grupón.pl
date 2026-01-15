/*GRUPÓN - CUPONES DE DESCUENTO*/
/*La nueva compañía emprendedora Grupón quiere lanzar un sistema de descuentos en productos y servicios de diferentes
marcas. Para eso está modelando el siguiente programa en Prolog: */

usuario(lider,capitalFederal).
usuario(alf,lanus).
usuario(roque,laPlata).
usuario(fede, capitalFederal).

/*El predicado accionDeUsuario registra las acciones que el usuario realiza en el sitio, que pueden ser: */

% cuponVigente(Ciudad, cupon(Marca,Producto,PorcentajeDescuento)).
cuponVigente(capitalFederal,cupon(elGatoNegro,setDeTe,35)).
cuponVigente(capitalFederal,cupon(lasMedialunasDelAbuelo,panDeQueso,43)).
cuponVigente(capitalFederal,cupon(laMuzzaInspiradora,pizzaYBirraParaDos,80)).
cuponVigente(lanus,cupon(maoriPilates,ochoClasesDePilates,75)).
cuponVigente(lanus,cupon(elTano,parrilladaLibre,65)).
cuponVigente(lanus,cupon(niniaBonita,depilacionDefinitiva,73)).

% accionDeUsuario(Usuario, compraCupon(PorcentajeDescuento,Fecha,Marca)).
accionDeUsuario(lider,compraCupon(60,"20/12/2010",laGourmet)).
accionDeUsuario(lider,compraCupon(50,"04/05/2011",elGatoNegro)).
accionDeUsuario(alf,compraCupon(74,"03/02/2011",elMundoDelBuceo)).
accionDeUsuario(fede,compraCupon(35,"05/06/2011",elTano)).

% accionDeUsuario(Usuario, recomiendaCupon(Marca,Fecha,UsuarioRecomendado)).
accionDeUsuario(fede,recomiendaCupon(elGatoNegro,"04/05/2011",lider)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"13/05/2011",alf)).
accionDeUsuario(alf,recomiendaCupon(cuspide,"13/05/2011",fede)).
accionDeUsuario(fede,recomiendaCupon(cuspide,"13/05/2011",roque)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"24/07/2011",fede)).

/*PUNTO 1:
Implementar el predicado 'ciudadGenerosa/1', donde una ciudad es generosa si todos sus cupones vigentes ofrecen más del
60% de descuento. Este predicado debe ser inversible.*/

ciudadGenerosa(Ciudad) :-
    usuario(_, Ciudad),
    forall(cuponVigente(Ciudad, Cupon), ofreceMasDelSesentaPorCiento(Cupon)).

ofreceMasDelSesentaPorCiento(cupon(_, _, PorcentajeDescuento)) :- PorcentajeDescuento > 60.



/*PUNTO ":
Implementar el predicado 'puntosGanados/2', quee relaciona a una persona y el total de puntos que ganó usando Grupón.
    - Por cada recomendación exitosa, el usuario gana 5 puntos.
    - Por cada cupón que haya comprado, el usuario gana 10 puntos.
    - Por cada recomendación no exitosa, el usuario gana 1 punto.
Nota: Se considera que una recomendación fue exitosa cuando un usuario A le recomendó a B una marca en una fecha y B
compró un cupón de esa marca en esa fecha.*/

puntosGanados(Persona, TotalPuntos) :-
    usuario(Persona, _),
    findall(Puntaje, calcularPuntaje(Persona, Puntaje), Puntajes),
    sum_list(Puntajes, TotalPuntos).

calcularPuntaje(Persona, Puntaje) :-
    accionDeUsuario(Persona, Accion),
    puntajeCupon(Accion, Puntaje).

puntajeCupon(recomiendaCupon(Marca, Fecha, UsuarioRecomendado), 5) :-
    recomendacionExitosa(recomiendaCupon(Marca, Fecha, UsuarioRecomendado)).

puntajeCupon(compraCupon(_, _, _), 10).

puntajeCupon(recomiendaCupon(Marca, Fecha, UsuarioRecomendado), 1) :-
    not(recomendacionExitosa(recomiendaCupon(Marca, Fecha, UsuarioRecomendado))).

recomendacionExitosa(recomiendaCupon(Marca, Fecha, UsuarioRecomendado)) :-
    accionDeUsuario(UsuarioRecomendado, compraCupon(_, Fecha, Marca)).



/*PUNTO 3:
Implementar el predicado 'promedioDePuntosPorMarca/2', que relaciona a una marca y el promedio de puntos que fueron
ganados a través de los cupones de esa marca.*/



/*PUNTO 4:
Implementar el predicado 'lePuedeInteresarElCupon/2' relaciona a una persona y un cupón vigente si la persona vive en
la ciudad donde se publica el cupón y además...
    - La persona ya compró algún cupón de la misma empresa del cupón vigente.
    - La persona le recomendaron algún cupón de la misma empresa del cupón vigente.*/

lePuedeInteresarElCupon(Persona, CuponVigente) :-
    viveDondeSePublicaElCupon(Persona, CuponVigente),
    comproORecomendoUnComponDeLaMismaEmpresa(Persona, CuponVigente).

viveDondeSePublicaElCupon(Persona, CuponVigente) :-
    cuponVigente(Ciudad, CuponVigente),
    usuario(Persona, Ciudad).

comproORecomendoUnComponDeLaMismaEmpresa(Persona, cupon(Marca, _, _)) :- accionDeUsuario(Persona, compraCupon(_, _, Marca)).
comproORecomendoUnComponDeLaMismaEmpresa(Persona, cupon(Marca, _, _)) :- accionDeUsuario(Persona, recomiendaCupon(Marca, _, _)).



/*PUNTO 5:
Implementar el predicado 'nadieLeDioBola/1', donde nadie le dio bola a un usuario si para cada recomendación que hizo,
ningún otro usuario hizo la compra del cupón para la misma marca y la misma fecha que recomendó.*/

nadieLeDioBola(Persona) :-  
    usuario(Persona, _),
    forall(accionDeUsuario(Persona, recomiendaCupon(Marca, Fecha, UsuarioRecomendado)), not(recomendacionExitosa(recomiendaCupon(Marca, Fecha, UsuarioRecomendado)))).



/*PUNTO 6:
Implementar el predicado 'cadenaDeRecomendacionesValida/3', que relaciona a una marca, una fecha y una lista, donde
la lista representa la cadena de recomendaciones que se hizo en esa fecha sobre esa marca. Por ejemplo:
    ?- cadenaDeRecomendacionesValida(cuspide,”13/05/2011”[lider,alf,fede]).
    true.
[lider,alf,fede] es una cadena de recomendaciones válida porque en la fecha 13/05/2011, lider le recomendó cuspide a
alf, alf se lo recomendó a fede y fede se lo recomendó a roque.
En cambio:
    ?- cadenaDeRecomendacionesValida(cuspide,”13/05/2011”,[lider,fede]).
    false.
[lider,fede] no es una cadena de recomendación válida porque lider le recomendó cuspide a fede el 24/07/2011 y fede
también hizo una recomendación de cuspide, pero el 13/05/2011.
Pistas:
    - Para que se considere una cadena de recomendaciones, ésta debe tener al menos 2 usuarios.
    - En la cadena de recomendaciones sólo entran los usuarios que recomiendan.
    - Pensar en términos recursivos la definición de 'cadena de recomendaciones de un usuario'.*/

cadenaDeRecomendacionesValida(_, _, [_]).

cadenaDeRecomendacionesValida(Marca, Fecha, [Usuario, OtroUsuario|RestoUsuarios]) :-
    accionDeUsuario(Usuario, recomiendaCupon(Marca, Fecha, OtroUsuario)),
    cadenaDeRecomendacionesValida(Marca, Fecha, [OtroUsuario|RestoUsuarios]).