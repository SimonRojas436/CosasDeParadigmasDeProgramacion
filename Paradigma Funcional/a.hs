data Ciudad = UnaCiudad { nombre :: String
            , anioFundacion :: Int
            , atracciones :: [String]
            , costoVida :: Float } deriving (Show)

baradero = UnaCiudad "Baradero" 1615 ["Parque del Este", "Museo Alejandro Barbich"] 150
nullish = UnaCiudad "Nullish" 1800 [] 140
caletaOlivia = UnaCiudad "Caleta Olivia" 1901 ["El Gorosito", "Faro Costanera"] 120
maipu = UnaCiudad "Maipú" 1878 ["Fortín Kakel"] 115
azul = UnaCiudad "Azul" 1832 ["Teatro Espanol", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"] 190


--FUNCIONES CORRESPONDIENTES AL PUNTO UNO--
valorCiudad :: Ciudad -> Float
valorCiudad ciudad
    | anioFundacion ciudad < 1800 = 5 * (1800 - fromIntegral (anioFundacion ciudad))
    | null (atracciones ciudad)  = 2 * (costoVida ciudad)
    | otherwise = 3 * (costoVida ciudad)


--FUNCIONES CORRESPONDIENTES AL PUNTO DOS--
atraccionCopada :: Ciudad -> Bool
atraccionCopada ciudad = any esVocal (atracciones ciudad)

longAtracciones :: Ciudad -> [Int]
longAtracciones ciudad = map (length) (atracciones ciudad)

ciudadSobria :: Ciudad -> Int -> Bool
ciudadSobria ciudad limite 
    | null (atracciones ciudad) = False
    | otherwise = all (> limite) (longAtracciones ciudad)

nombreRaroCiudad :: Ciudad -> Bool
nombreRaroCiudad ciudad = length (nombre ciudad) < 5

esVocal :: String -> Bool
esVocal cadena = (head cadena) `elem` ['A', 'a', 'E', 'e', 'I', 'i', 'O', 'o', 'U', 'u']


--FUNCIONES CORRESPONDIENTES AL PUNTO TRES--
agregarAtraccion :: Ciudad -> String -> Ciudad
agregarAtraccion ciudad nuevaAtraccion = ciudad { costoVida = costoVida ciudad * 1.2, atracciones = atracciones ciudad ++ [nuevaAtraccion] }

crisis :: Ciudad -> Ciudad
crisis ciudad 
    | null (atracciones ciudad) = ciudad { costoVida = (costoVida ciudad) * 0.9 } 
    | otherwise = ciudad { costoVida = costoVida ciudad * 0.9 , atracciones = init (atracciones ciudad) }

remodelacion :: Ciudad -> Float -> Ciudad
remodelacion ciudad porcentaje = ciudad { costoVida = (costoVida ciudad) * (dePorcentajeAFloat porcentaje), nombre = "New " ++ (nombre ciudad) }

reevaluacion :: Ciudad -> Int -> Ciudad
reevaluacion ciudad limite
        | ciudadSobria ciudad limite == True = ciudad { costoVida = (costoVida ciudad) * 1.1 }
        | otherwise = ciudad { costoVida = (costoVida ciudad) - 3 }

dePorcentajeAFloat :: Float -> Float
dePorcentajeAFloat x = 1 + (x/100)




---------------------------------------------------------PARTE 2-------------------------------------------------
--FUNCIONES CORRESPONDIENTES AL PUNTO CUATRO--

--4.1) Definimos en año con: el numero que le corresponde y una seria de eventos que pasaron.
--data Anio = UnAnio { anio :: Int --O String?
--                   , eventos :: ["Funciones"] } deriving (Show)

--aniosPasan :: Ciudad -> Anio -> Ciudad

--4.2) Funcion que reciba una ciudad, un criterio de comparacion y un evento, 

--algoMejor :: Ciudad -> "Funcion" -> Bool

--4.3) Funcion que aplique sobre una ciudad todas las funciones que suben el costo de vida

--subeCostoVida :: Ciudad -> Anio -> Ciudad

--4.4) Funcion que aplique sobre una ciudad todas las funciones que bajen el costo de vida

--bajaCostoVida :: Ciudad -> Anio -> Ciudad

--4.5) ?

--FUNCIONES CORRESPONDIENTES AL PUNTO CINCO--

--5.1) Dado un año, y una lista de ciudades, saber si esta ordenada (costo de vida al aplicar el evento sobre cada una es creciente)

--5.2) Dado un evento y una lista de ciudades, saber si la lista esta ordenda, (Costo de vida de cada ciudad en orden creciente)

--5.3) Dada una lista de años y una ciudad, y habiendo aplicado todos los eventos del año a la ciudad, termina en una seria de costos ascendentes?
            --Tenemos estos años modelados:
                        --"2021" = [crisis, agregarAtraccion "playa"]
                        --"2022" = [crisis, remodelacion 5%, reevaluacion 7]
                        --"2023" = [crisis, agregarAtraccion "parque", remodelacion 10%, remodelacion 20%] 