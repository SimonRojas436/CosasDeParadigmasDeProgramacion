--SOLUCIÓN PARCIAL: DUNE--

--LOS FREMEN--
data Fremen = UnFremen { nombre :: String
                       , tolerancia :: Float
                       , titulos :: [String]
                       , reconocimiento :: Int } deriving (Show)

stilgar :: Fremen
stilgar = UnFremen "Stilgar" 150 ["guia"] 3

otro :: Fremen
otro = UnFremen "Otro" 120 ["domador", "comico"] 5

--1.a)
nuevoReconocimiento :: Fremen -> Fremen
nuevoReconocimiento fremen = fremen { reconocimiento = reconocimiento fremen + 1 }

--1.b)
hayCandidatoElegido :: [Fremen] -> Bool
hayCandidatoElegido = any esCandidatoElegido

esCandidatoElegido :: Fremen -> Bool
esCandidatoElegido fremen = (tieneDomador fremen) && (tolerancia fremen > 100)

tieneDomador :: Fremen -> Bool
tieneDomador = ((elem "domador").titulos)

--1.c)
elegido :: [Fremen] -> Fremen
elegido = (buscarElegido.(filter esCandidatoElegido))

buscarElegido :: [Fremen] -> Fremen --La funcion no considera que se reciba una lista vacia por conveniencia.
buscarElegido [x] = x
buscarElegido (x:y:xs)
    | (reconocimiento x) > (reconocimiento y) = buscarElegido (x:xs)
    | otherwise = buscarElegido (y:xs)




--GUSANOS DE ARENA--
data Gusano = UnGusano { longitud :: Float
                       , nivelHidratacion :: Int
                       , descripcion :: [String] } deriving (Show)

reproducir :: Gusano -> Gusano -> Gusano
reproducir gusano1 gusano2 = UnGusano { longitud = max (longitud gusano1) (longitud gusano2) * 0.1, nivelHidratacion = 0, descripcion =  descripcion gusano1 ++ descripcion gusano2 }

gusanoUno :: Gusano
gusanoUno = UnGusano 10 5 ["rojo con lunares"]

gusanoDos :: Gusano
gusanoDos = UnGusano 8 1 ["dientes puntiagudos"]

--2.a)
listaApareo :: [Gusano] -> [Gusano] -> [Gusano]
listaApareo [] [] = []
listaApareo [_] [] = [] --Si la primera está vacia
listaApareo [] [_] = [] --Si la segunda está vacia
listaApareo (p:ps) (m:ms) = [reproducir p m] ++ (listaApareo ps ms)




--MISIONES--
type Mision = Gusano -> Fremen -> Fremen

domarGusanoArena :: Mision
domarGusanoArena gusano fremen
    | (puedeDomarlo fremen gusano) = fremen { tolerancia = tolerancia fremen + 100, titulos = ["domador"] ++ titulos fremen }
    | otherwise = fremen { tolerancia = tolerancia fremen * 0.90 }

puedeDomarlo :: Fremen -> Gusano -> Bool
puedeDomarlo fremen gusano = (tolerancia fremen) > (longitud gusano / 2.0)

destruirGusanosArena :: Mision
destruirGusanosArena gusano fremen
   | (tieneDomador fremen) && (not (puedeDomarlo fremen gusano)) = fremen { tolerancia = tolerancia fremen + 100, reconocimiento = reconocimiento fremen + 1 }
   | otherwise = fremen { tolerancia = tolerancia fremen * 0.80 }

--3.a)
--Comer gusano de arena:
    --Un Fremen se puede comer a un gusano de arena si la longitud del gusano es menor a una longitud esperada.
    --Al hacerlo, obtiene el título de "Devorador de bestias" y su tolerancia a la especia aumenta en 200 unidades.
    --Si no lo puede hacer su tolerancia a la Especia baja un 5%, se le quita un reconocimiento y se le agrega el titulo "Cobarde".

comerGusanoArena :: Float -> Mision
comerGusanoArena longitudEsperada gusano fremen
    | (longitud gusano) < longitudEsperada = fremen { tolerancia = tolerancia fremen + 200, titulos = ["devorador de bestias"] ++ titulos fremen }
    | otherwise = fremen { tolerancia = tolerancia fremen * 0.95, titulos = ["cobarde"] ++ titulos fremen, reconocimiento = reconocimiento fremen - 1}

--3.b)
misionColectiva :: Mision -> Gusano -> [Fremen] -> [Fremen]
misionColectiva mision gusano = map (mision gusano)

--3.c)
esDiferenteElegido :: Mision -> Gusano -> [Fremen] -> Bool
esDiferenteElegido mision gusano tribu = (nombre (elegido tribu)) /= (nombre (elegido (misionColectiva mision gusano tribu)))




--AL INFINITO--
listaInfinitaStilgar :: [Fremen]
listaInfinitaStilgar = repeat stilgar

listaInfinitaOtro :: [Fremen]
listaInfinitaOtro = repeat otro

--4.a)
    --La funcion realiza la misión con cada integrante de la tribu, que al ser infinita, nunca termina de devolver un resultado.
    --Por lo tanto, nunca devuelve la tribu despues de haber realizado la misión colectiva.
    --Por ejemplo: misionColectiva comerGusanoArena gusanoUno listaInfinitaStilgar
    --Resultado: una lista infinita.

--4.b)
    --La funcion se detendrá cuando encuentre a algún fremen que sea candidato.
    --Por ejemplo: hayCandidatoElegido listaInfinitaOtro
    --Resultado: True
    --Sin embargo, en su busquedad, si en la lista no hay ningún fremen que cumpla con lo pedido, la recorrerá infinitamente.
    --Por ejemplo: hayCandidatoElegido listaInfinitaStilgar

--4.c)
    --La función no devuelve nada, sino que realiza una busqueda infinita. Es decir, en su propia composicion
    --la funcion necesita recibir una lista con aquellos fremen que son candidatos, acción que nunca termina.
    --Por ejemplo: elegido listaInfinitaOtro
    --Resultado: la funcion espera recibir una lista, que no llega al ser infinita.
