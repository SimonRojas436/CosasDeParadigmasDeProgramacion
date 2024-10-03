--NOMUS--
data Nomu = UnNomu { tieneAlas :: Bool
                   , tieneBrazos :: Bool
                   , cantOjos :: Int
                   , colorPiel :: String
                   , cantVida :: Int
                   , cantFuerza :: Int
                   , poderes :: [Poder] } deriving (Show)

data Poder = UnPoder { cantCuracion :: Int
                     , cantDanio :: Int
                     , rangoAtaque :: Int
                     , probCritico :: Float } deriving (Show)


--DE LA FUNCIONES CORRESPONDIENTES A LA PRIMERA PARTE DEL ENUNCIADO--
categoriaNomu :: Nomu -> String
categoriaNomu nomu
    | cantF > 10000 = "High end"
    | cantF > 3000 = "Fuerte"
    | cantF > 1000 = "Común"
    | otherwise = "Pichi"
    where cantF = (cantFuerza nomu)

puedeVer :: Nomu -> Bool
puedeVer nomu = (cantOjos nomu) > 0


--DE LAS FUNCIONES CORRESPONDIENTES A LA SEGUNDA PARTE DEL ENUNCIADO--
probabilidadCritico :: Nomu -> Float
probabilidadCritico nomu = probCritico (last (poderes nomu))

cuerpoCuerpo :: Nomu -> Int -> Bool
cuerpoCuerpo nomu posicion = rangoAtaque ((poderes nomu) !! posicion) < 100

soloCuracion :: Nomu -> Int -> Bool
soloCuracion nomu posicion = (cantCuracion ((poderes nomu) !! posicion) /= 0) && (cantDanio ((poderes nomu) !! posicion) == 0)


--FUNCIONES OTRAS--
irAlGimnasio :: Nomu -> Nomu
irAlGimnasio (UnNomu alas brazos ojos piel vida fuerza poderes) = (UnNomu alas brazos ojos piel vida (fuerza * 15) poderes)

puedeVolar :: Nomu -> Bool
puedeVolar nomu = (tieneAlas nomu) == True

nomuPoderoso :: Nomu -> Bool
nomuPoderoso nomu = (cantFuerza nomu) > 35

conBrazos :: Nomu -> Bool
conBrazos nomu = (tieneBrazos nomu) == True


--PREVIO A LA PRÁCTICA DE ORDEN SUPERIOR Y COMPOSICIÓN--
uno = UnNomu True True 0 "azul" 100 22 [UnPoder 10 20 30 0.4]
dos = UnNomu False False 2 "gris" 500 23 [UnPoder 30 20 10 0.1]
tres = UnNomu True True 3 "negro" 200 40 [UnPoder 150 220 430 0.24]

listaNomus :: [Nomu]
listaNomus = [uno, dos, tres]

agregarNomu :: Nomu -> [Nomu]
agregarNomu nomu = nomu : listaNomus


--DE LAS FUNCIONES CORRESPONDIENTES A LA PRÁCTICA DE ORDEN SUPERIOR Y COMPOSICIÓN--
--UNO--
listaNomusGym :: [Nomu] -> [Nomu]
listaNomusGym listaNomus = map (irAlGimnasio) listaNomus

--DOS--
listaNomusAlas :: [Nomu] -> [Nomu]
listaNomusAlas listaNomus = filter (puedeVolar) listaNomus

--Tres--
todosNomusPoderosos :: [Nomu] -> Bool
todosNomusPoderosos listaNomus = all (nomuPoderoso) listaNomus

--Cuatro--
brazosPoderosos :: [Nomu] -> Bool
brazosPoderosos listaNomus = (todosNomusPoderosos.(filter conBrazos)) listaNomus

--Cinco--
gymPoderosos :: [Nomu] -> Bool
gymPoderosos listaNomus = (todosNomusPoderosos.(map irAlGimnasio)) listaNomus