import Text.Show.Functions 

--Struct de Ciudades
data Ciudad = UnaCiudad { nombre :: String
            , anioFundacion :: Int
            , atracciones :: [String]
            , costoVida :: Float } deriving (Show)

type Evento = Ciudad -> Ciudad

data Anio = UnAnio { anio :: Int
          , eventos :: [Ciudad -> Ciudad] }

                   
--Ciudades Predefinidas
baradero = UnaCiudad "Baradero" 1615 ["Parque del Este", "Museo Alejandro Barbich"] 150
nullish = UnaCiudad "Nullish" 1800 [] 140
caletaOlivia = UnaCiudad "Caleta Olivia" 1901 ["El Gorosito", "Faro Costanera"] 120
maipu = UnaCiudad "Maipú" 1878 ["Fortín Kakel"] 115
azul = UnaCiudad "Azul" 1832 ["Teatro Espanol", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"] 190

--Años Predefinidos
anio15 = UnAnio 2015 []
anio21 = UnAnio 2021 [crisis, agregarAtraccion "playa"]
anio22 = UnAnio 2022 [crisis, remodelacion 5, reevaluacion 7]
anio23 = UnAnio 2023 [crisis, agregarAtraccion "parque", remodelacion 10, remodelacion 20]
anio24 = UnAnio 2024 listaInfinita

--      //Funciones//
--      //Punto 1//
--Definir valor costoVida
valorCiudad :: Ciudad -> Float
valorCiudad ciudad
    | anioFundacion ciudad < 1800 = 5 * (1800 - fromIntegral (anioFundacion ciudad))
    | null (atracciones ciudad)  = 2 * (costoVida ciudad)
    | otherwise = 3 * (costoVida ciudad)


--       //Punto 2//
--Atraccion copada
--Es copada si empieza por vocal
esVocal :: String -> Bool
esVocal cadena = (head cadena) `elem` ['A', 'a', 'E', 'e', 'I', 'i', 'O', 'o', 'U', 'u']

atraccionCopada :: Ciudad -> Bool
atraccionCopada ciudad = any esVocal (atracciones ciudad)

--Población sobria
--Es sobria si la suma de las atracciones da menos a n
--siendo n un valor definido por el usuario
longAtracciones :: Ciudad -> [Int]
longAtracciones ciudad = map (length) (atracciones ciudad)

ciudadSobria :: Ciudad -> Int -> Bool
ciudadSobria ciudad limite 
    | null (atracciones ciudad) = False
    | otherwise = all (> limite) (longAtracciones ciudad)

--Nombre raro
--Tiene nombre raro si tiene menos de 5 letras
nombreRaroCiudad :: Ciudad -> Bool
nombreRaroCiudad ciudad = ((5>).length) (nombre ciudad)

--      //Punto 3//
-- FUNCIONES NECESARIAS
modificarCostoVida :: Float -> Evento
modificarCostoVida valor ciudad = ciudad {costoVida = costoVida ciudad * valor} 

dePorcentajeAFloat :: Float -> Float
dePorcentajeAFloat x = 1 + (x/100)
--Sumar una nueva atraccion
--incrementa el costo de vida un 20%
agregarAtraccion :: String -> Evento
agregarAtraccion nuevaAtraccion ciudad = modificarCostoVida 1.2 ciudad { atracciones = atracciones ciudad ++ [nuevaAtraccion] }

--Crisis
--baja el costo de vida un 10% y 
--cierra la ultima atraccion de la lista
crisis :: Evento
crisis ciudad 
    | null (atracciones ciudad) = modificarCostoVida 0.9 ciudad
    | otherwise = modificarCostoVida 0.9 ciudad {atracciones = init (atracciones ciudad) } 

--Remodelacion
--se incremente el costo de vida X
--le agrega el prefijo "New" al nombre

remodelacion :: Float -> Evento
remodelacion porcentaje ciudad = modificarCostoVida (dePorcentajeAFloat porcentaje) ciudad {nombre = "New " ++ (nombre ciudad) }

--Reevaluacion
--Si la ciudad es sobria, con un limite indicado por el usuario,
--se aumenta el costoVida un 10%, caso contrario baja 3 puntos.
reevaluacion :: Int -> Evento
reevaluacion limite ciudad
        |ciudadSobria ciudad limite= modificarCostoVida 1.1 ciudad
        |otherwise =  ciudad { costoVida = (costoVida ciudad) - 3 }


--      //Punto 4//
--Composición de remodelación,crisis y reevaluación. En ese orden.
serieEventosDesafortunados :: Float -> Int -> Evento
serieEventosDesafortunados porcentaje limite ciudad= ((remodelacion porcentaje) . (crisis) . (reevaluacion limite)) ciudad






---------------------DEL TP PARTE 2-------------------------------------------

--      //Punto 4//
--      //Punto 4.1//
aniosPasan :: Anio -> Evento
aniosPasan anio ciudad = foldl (\ciudad evento -> evento ciudad) ciudad (eventos anio)

--      //Punto 4.2//
algoMejor ::  (Ord a) => Ciudad -> Evento -> (Ciudad -> a) -> Bool
algoMejor ciudad evento criterioComparacion= criterioComparacion (evento ciudad)>criterioComparacion ciudad

--      //Punto 4.3//
subeCostoVida :: Anio -> Evento
subeCostoVida anio ciudad = foldl (\ciudad evento -> aplicarEventoQueSubeCostoVida evento ciudad) ciudad (eventos anio)

aplicarEventoQueSubeCostoVida :: (Evento) -> Evento
aplicarEventoQueSubeCostoVida evento ciudad
    | (costoVida (evento ciudad)) > (costoVida ciudad) = (evento ciudad)
    | otherwise = ciudad

--      //Punto 4.4//
bajaCostoVida :: Anio -> Evento
bajaCostoVida anio ciudad = foldl (\ciudad evento -> aplicarEventoQueBaja evento ciudad) ciudad (eventos anio)

aplicarEventoQueBaja :: (Evento) -> Evento
aplicarEventoQueBaja evento ciudad
    | (costoVida (evento ciudad)) < (costoVida ciudad) = (evento ciudad)
    | otherwise = ciudad

--      //Punto 4.5//
-- Se aplicarán unicamente los eventos que hagan que el valor de la ciudad suba
subeValorCiudad :: Anio -> Evento
subeValorCiudad anio ciudad = foldl (\ciudad evento -> aplicarEventoQueSubeValor evento ciudad) ciudad (eventos anio)

aplicarEventoQueSubeValor :: (Evento) -> Evento
aplicarEventoQueSubeValor evento ciudad
    | (valorCiudad (evento ciudad)) > (valorCiudad ciudad) = (evento ciudad)
    | otherwise = ciudad

--      //Punto 5//
--      //Punto 5.1//
eventosOrdenados :: Anio -> Ciudad -> Bool
eventosOrdenados anio ciudad = (listaOrdenada.(despuesDeEventos ciudad)) (eventos anio)

despuesDeEventos :: Ciudad -> [Evento] -> [Float]
despuesDeEventos _ [] = [] --Vacia
despuesDeEventos ciudad (x:[]) = [costoVida (x ciudad)] --Un elemento
despuesDeEventos ciudad (x:y:xs) = (costoVida (x ciudad)) : (despuesDeEventos ciudad (y:xs))

listaOrdenada :: [Float] -> Bool
listaOrdenada [] = True --Vacia
listaOrdenada [_] = True -- Un elemento
listaOrdenada (x:y:xs) = (x <= y) && (listaOrdenada (y:xs))

--      //Punto 5.2//
ciudadesOrdenadas :: (Evento) -> [Ciudad] -> Bool
ciudadesOrdenadas evento listaCiudades = ((listaOrdenada).(map costoVida).(map evento)) listaCiudades

--      //Punto 5.3//
aniosOrdenados :: [Anio] -> Ciudad -> Bool
aniosOrdenados listaAnios ciudad = listaOrdenada (map (costoVida . aplicarEventos ciudad) listaAnios)

aplicarEventos :: Ciudad -> Anio -> Ciudad
aplicarEventos ciudad anio = foldl (flip ($)) ciudad (eventos anio)

--      //Punto 6//
listaInfinita :: [Evento]
listaInfinita =repeat (crisis) 

En primer lugar, la función de eventos ordenados no puede aplicarse para anio24, el año con la lista de eventos infinita,
ya que en la función se requiere dicha lista (eventos anio) lo cual no permite que se termine de evaluar,
entrando en un sinfín de ejecuciones. Ahora, en contraposición a este caso se encuentra la función de aniosOrdenados, 
ya que aquí, si bien se requiere una lista de años en los cuales se puede incluir el anio24,
la parte de eventos infinitos no se trabaja y a pesar de que exista, la cualidad de evaluación diferida 
nos permite seguir adelante sin mayor complicación. Finalizando, en cuanto a la función ciudadesOrdenadas, 
esta no recibe en ningún momento como parámetro ningún año, solo un evento y una lista de ciudades, 
por lo que no hay ningún conflicto de convergencia en este ítem.


