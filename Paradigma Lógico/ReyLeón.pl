/*EL REY LEÓN*/

/*En la jungla tan imponente el león rey duerme ya... Y Timón y Pumba salieron a lastrar bichos. Tenemos tres tipos de
bichos, representados por functores: las vaquitas de San Antonio (de quienes nos interesa un peso), las cucarachas (de
quienes nos interesa un tamaño y un peso) y las hormigas, que pesan siempre lo mismo. De los personajes también se conoce
el peso, mediante hechos. La base de conocimiento es la que sigue:*/

comio(pumba, vaquitaSanAntonio(gervasia,3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger,15,6)).
comio(pumba, cucaracha(erikElRojo,25,70)).
comio(timon, vaquitaSanAntonio(romualda,4)).
comio(timon, cucaracha(gimeno,12,8)).
comio(timon, cucaracha(cucurucha,12,5)).
comio(simba, vaquitaSanAntonio(remeditos,4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).
comio(shenzi,hormiga(conCaraDeSimba)).

peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).
peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).
peso(hormiga(_), 2).
peso(vaquitaSanAntonio(_, Peso), Peso).
peso(cucaracha(_, _, Peso), Peso).

personaje(pumba).
personaje(timon).
personaje(simba).
personaje(scar).
personaje(shenzi).
personaje(banzai).



/*PUNTO 1: A FALTA DE POCHOCLOS...
    A. Qué cucaracha es jugosita: ó sea, hay otra con su mismo tamaño pero ella es más gordita.
    B. Si un personaje es hormigofílico... (Comió al menos dos hormigas).
    C. Si un personaje es cucarachofóbico (no comió cucarachas).
    D. Conocer al conjunto de los picarones. Un personaje es picarón si comió una cucaracha jugosita ó si se come a
       Remeditos la vaquita. Además, pumba es picarón de por sí.*/

/*A*/
cucarachaJugosita(cucaracha(Cucaracha, Tamanio, Peso)) :-
    comio(_, cucaracha(OtraCucaracha, Tamanio, OtroPeso)),
    Cucaracha \= OtraCucaracha,
    Peso > OtroPeso.

/*B*/
hormigofilico(Personaje) :-
    comio(Personaje, hormiga(Hormiga)),
    comio(Personaje, hormiga(OtraHormiga)),
    Hormiga \= OtraHormiga.

/*C*/
cucarachofobico(Personaje) :-
    comio(Personaje, _),
    not(comio(Personaje, cucaracha(_, _, _))).

/*D*/
picarones(Picarones) :-
    findall(Personaje, esPicaron(Personaje), Picarones).

esPicaron(Personaje) :- comio(Personaje, Cucaracha), cucarachaJugosita(Cucaracha).
esPicaron(Personaje) :- comio(Personaje, vaquitaSanAntonio(remeditos, _)).
esPicaron(pumba).



/*PUNTO 2: PERO YO QUIERO CARNE...
Aparece en escena el malvado Scar, que persigue a algunos de nuestros amigos. Y a su vez, las hienas Shenzi y Banzai
también se divierten...
    A. Se quiere saber cuánto engorda un personaje (sabiendo que engorda una cantidad igual a la suma de los pesos de
       todos los bichos en su menú). Los bichos no engordan.
    B. Pero como indica la ley de la selva, cuando un personaje persigue a otro, se lo termina comiendo, y por lo tanto
       también engorda. Realizar una nueva version del predicado cuantoEngorda.
    C. Ahora se complica el asunto, porque en realidad cada animal antes de comerse a sus víctimas espera a que estas
       se alimenten. De esta manera, lo que engorda un animal no es sólo el peso original de sus víctimas, sino también
       hay que tener en cuenta lo que éstas comieron y por lo tanto engordaron. Hacer una última version del predicado.*/

persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).
persigue(scar, mufasa).

cuantoEngorda(Personaje, Peso) :-
    personaje(Personaje),
    findall(Peso, pesoDeLoQueComio(Personaje, Peso), Pesos),
    sum_list(Pesos, Peso).

/*A*/
/*Solo comtempla que se coman bichos.*/
pesoDeLoQueComio(Personaje, Peso) :-
    comio(Personaje, Bicho),
    peso(Bicho, Peso).

/*B*/
/*Solo comtempla que se coman otros Personajes.*/
pesoDeLoQueComio(Personaje, Peso) :-
    persigue(Personaje, OtroPersonaje),
    peso(OtroPersonaje, Peso).


/*C*/
/*Peso de lo que comio el personaje perseguido.*/
pesoDeLoQueComio(Personaje, Peso) :-
    persigue(Personaje, OtroPersonaje),
    pesoDeLoQueComio(OtroPersonaje, Peso).



/*PUNTO 3: BUSCANDO AL REY...
Sabiendo que todo animal adora a todo lo que no se lo come o no lo persigue, encontrar al rey. El rey es el animal a
quien sólo hay un animal que lo persigue y todos adoran. Agrege el hecho: persigue(scar, mufasa).*/