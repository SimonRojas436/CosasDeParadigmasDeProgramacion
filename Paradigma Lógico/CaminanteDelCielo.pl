/*CAMINANTE DEL CIELO*/
%                            UN ANÁLISIS PREDICTIVO DE LA SAGA MAS INFLUYENTE DEL CINE
%                                            El miedo lleva a la ira.
%                                              La ira lleva al odio.
%                                          El odio lleva al sufrimiento.
%                                         Y el sufrimiento al Lado Oscuro.
%                                       Cuidado con el miedo, joven padawan. 
/*"¡Es lógico! pasaAlLadoOscuro(Alguien) :- tieneMiedo(Alguien)." Joven Padawan de prolog.*/

% apareceEn(Personaje, Episodio, Lado de la luz).
apareceEn(luke, elImperioContrataca, luminoso).
apareceEn(luke, unaNuevaEsperanza, luminoso).

apareceEn(vader, unaNuevaEsperanza, oscuro).
apareceEn(vader, laVenganzaDeLosSith, luminoso).
apareceEn(vader, laAmenazaFantasma, luminoso).
apareceEn(c3po, laAmenazaFantasma, luminoso).
apareceEn(c3po, unaNuevaEsperanza, luminoso).
apareceEn(c3po, elImperioContrataca, luminoso).
apareceEn(chewbacca, elImperioContrataca, luminoso).
apareceEn(yoda, elAtaqueDeLosClones, luminoso).
apareceEn(yoda, laAmenazaFantasma, luminoso).

% maestro(Personaje)
maestro(luke).
maestro(leia).
maestro(vader).
maestro(yoda).
maestro(rey).
maestro(duku).

% caracterizacion(Personaje,Aspecto).
% aspectos: ser(Especie,Tamaño), humano, robot(Forma).
caracterizacion(chewbacca, ser(wookiee, 10)).
caracterizacion(luke, humano).
caracterizacion(vader, humano).
caracterizacion(yoda, ser(desconocido,5)).
caracterizacion(jabba, ser(hutt, 20)).
caracterizacion(c3po, robot(humanoide)).
caracterizacion(bb8, robot(esfera)).
caracterizacion(r2d2, robot(secarropas)).

% elementosPresentes(Episodio, Dispositivos).
elementosPresentes(laAmenazaFantasma, [sableLaser]).
elementosPresentes(elAtaqueDeLosClones, [sableLaser, clon]).
elementosPresentes(laVenganzaDeLosSith, [sableLaser, mascara, estrellaMuerte]).
elementosPresentes(unaNuevaEsperanza, [estrellaMuerte, sableLaser, halconMilenario]).
elementosPresentes(elImperioContrataca, [mapaEstelar, estrellaMuerte]).

% precedeA(EpisodioAnterior,EpisodioSiguiente).
precedeA(laAmenazaFantasma, elAtaqueDeLosClones).
precedeA(elAtaqueDeLosClones, laVenganzaDeLosSith).
precedeA(laVenganzaDeLosSith, unaNuevaEsperanza).
precedeA(unaNuevaEsperanza, elImperioContrataca).

/*El objetivo principal es deducir las principales características del próximo episodio. En particular, se busca definir
un predicado:
    nuevoEpisodio(Heroe, Villano, Extra, Dispositivo).
Que permita relacionar a un personaje que sea el héroe del episodio con su correspondiente villano, junto con un personaje
extra que le aporta mística y un dispositivo especial que resulta importante para la trama.
Las condiciones que deben cumplirse simultáneamente son las siguientes:*/

nuevoEpisodio(Heroe, Villano, Extra, Dispositivo) :-
    aparecenAnteriormenteYSonDistintos(Heroe, Villano, Extra),
    nuncaPasoAlLadoOscuro(Heroe),
    aparecioVariasVecesYEsAmbiguo(Villano),
    esExoticoYTieneVinculoEstrecho(Extra, Heroe, Villano),
    reconociblePorElPublico(Dispositivo).

/*A*/
/*No se quiere innovar tanto, los personajes deben haber aparecido en alguno de los episodios anteriores y obviamente
ser diferentes.*/

aparecenAnteriormenteYSonDistintos(Heroe, Villano, Extra) :-
    aparecenAnteriormente(Heroe, Villano, Extra),
    sonDistintos(Heroe, Villano, Extra).

aparecenAnteriormente(Heroe, Villano, Extra) :-
    apareceEn(Heroe, _, _),
    apareceEn(Villano, _, _),
    apareceEn(Extra, _, _).

sonDistintos(Heroe, Villano, Extra) :- Heroe \= Villano, Villano \= Extra, Extra \= Heroe.

/*B*/
/*Para mantener el espíritu clásico, el héroe tiene que ser un jedi (un maestro que estuvo alguna vez en el lado luminoso)
que nunca se haya pasado al lado oscuro.*/

nuncaPasoAlLadoOscuro(Heroe) :-
    maestro(Heroe),
    not(apareceEn(Heroe, _, oscuro)).

/*C*/
/*El villano debe haber estado en más de un episodio y tiene que mantener algún rasgo de ambigüedad, por lo que se debe
garantizar que haya aparecido del lado luminoso en algún episodio y del lado oscuro en el mismo episodio o en un episodio
posterior.*/

aparecioVariasVecesYEsAmbiguo(Villano) :-
    aparecioVariasVeces(Villano),
    esAmbiguo(Villano).

aparecioVariasVeces(Villano) :-
    apareceEn(Villano, Episodio, _),
    apareceEn(Villano, OtroEpisodio, _),
    Episodio \= OtroEpisodio.

esAmbiguo(Villano) :-
    apareceEn(Villano, Episodio, luminoso),
    seVuelveOscuro(Villano, Episodio).

seVuelveOscuro(Villano, Episodio) :- apareceEn(Villano, Episodio, oscuro).

seVuelveOscuro(Villano, Episodio) :-
    not(apareceEn(Villano, Episodio, oscuro)),
    precedeA(Episodio, EpisodioSiguiente),
    seVuelveOscuro(Villano, EpisodioSiguiente).

/*D*/
/*El extra tiene que ser un personaje de aspecto exótico para mantener la estética de la saga. Tiene que tener un vínculo
estrecho con los protagonistas, que consiste en que haya estado junto al heroe o al villano en todos los episodios en los
que dicho extra apareció. Se considera exótico a los robots que no tengan forma de esfera y a los seres de gran tamaño
(mayor a 15) o de especie desconocida.*/

esExoticoYTieneVinculoEstrecho(Extra, Heroe, Villano) :-
    esExotico(Extra),
    tieneVinculoEstrecho(Extra, Heroe, Villano).

esExotico(Extra) :- caracterizacion(Extra, robot(_)), not(caracterizacion(Extra, robot(esfera))).
esExotico(Extra) :- caracterizacion(Extra, ser(_, Tamanio)), Tamanio > 15.
esExotico(Extra) :- caracterizacion(Extra, ser(desconocido, _)).

tieneVinculoEstrecho(Extra, Heroe, Villano) :-
    forall(apareceEn(Extra, Episodio, _), apareceCon(Heroe, Villano, Episodio)).

apareceCon(Heroe, _, Episodio) :- apareceEn(Heroe, Episodio, _).
apareceCon(_, Villano, Episodio) :- apareceEn(Villano, Episodio, _).

/*E*/
/*El dispositivo tiene que ser reconocible por el público, por lo que tiene que ser un elemento que haya estado presente
en muchos episodios (3 o más).*/

reconociblePorElPublico(Dispositivo) :-
    apareceEl(Dispositivo, _),
    findall(Episodio, apareceEl(Dispositivo, Episodio), Episodios),
    length(Episodios, CantEpisodios),
    CantEpisodios >= 3.

apareceEl(Dispositivo, Episodio) :-
    elementosPresentes(Episodio, Dispositivos),
    member(Dispositivo, Dispositivos).

/*PUNTO 1:
Verificar si una determinada conformación del episodio es válida. Por ejemplo:
    ?- nuevoEpisodio(luke, vader, c3po, estrellaMuerte).
    true.*/

/*PUNTO 2:
Encontrar todas las conformaciones posibles que se puedan armar. Mostrar ejemplos de consultas y respuestas.*/

/*PRIMERA COMBINACIÓN:
    Heroe = luke,
    Villano = vader,
    Extra = c3po,
    Dispositivo = estrellaMuerte.*/

/*SEGUNDA COMBINACION:
    Heroe = luke,
    Villano = vader,
    Extra = c3po,
    Dispositivo = sableLaser.*/

/*PUNTO 3:
Agregar algunos personajes nuevos, con una manera propia de describir su aspecto y con una logica diferente para ser
incluido como extras.*/