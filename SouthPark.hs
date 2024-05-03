--South Park--
data Personaje = UnPersonaje { nombre :: String
                             , cantDinero :: Int
                             , nivelFelicidad :: Int } deriving (Show)


--DE LA FUNCIONES CORRESPONDIENTES A LA PRIMERA PARTE DEL ENUNCIADO--
irEscuelaPrimaria :: Personaje -> Personaje
irEscuelaPrimaria personaje
    | (nombre personaje) == "Butters" = personaje { nivelFelicidad = nivelFelicidad personaje + 20 }
    | otherwise = personaje { nivelFelicidad = restaSegura (nivelFelicidad personaje) 20 }

comerCheesyPoofs :: Personaje -> Int -> Personaje
comerCheesyPoofs personaje cantCheesyPoofs = personaje { cantDinero = ((cantDinero personaje -).(* 10)) cantCheesyPoofs
                                                       , nivelFelicidad = ((+ nivelFelicidad personaje).(* 10)) cantCheesyPoofs }

irAlTrabajo :: Personaje -> String -> Personaje
irAlTrabajo personaje trabajo = personaje { cantDinero = cantDinero personaje + length trabajo }

dobleTurno :: Personaje -> String -> Personaje
dobleTurno personaje trabajo = personaje { cantDinero = ((+ cantDinero personaje).(* 2).length) trabajo
                                         , nivelFelicidad = restaSegura (nivelFelicidad personaje) (length trabajo) }

jugarWow :: Personaje -> Int -> Int -> Personaje
jugarWow personaje cantAmigos cantHorasJugadas = personaje { cantDinero = ((cantDinero personaje -).(* 10)) cantHorasJugadas
                                                           , nivelFelicidad = ((+ nivelFelicidad personaje).(* cantAmigos).(* 10).(min 5)) cantHorasJugadas }

verPelicula :: Personaje -> Personaje --Ver una pelicula: suma 5 puntos de felicidad, no resta 3 de dinero--
verPelicula personaje = personaje { cantDinero = cantDinero personaje - 3
                                  , nivelFelicidad = nivelFelicidad personaje + 5 }

--Ejemplos de invocación--
cartmanCome :: Personaje
cartmanCome = comerCheesyPoofs cartman 12

stanDobleTurno :: Personaje
stanDobleTurno = dobleTurno stan "barrer la nieve"

buttersIrEscuelaVerPelicula :: Personaje
buttersIrEscuelaVerPelicula = (verPelicula.irEscuelaPrimaria) butters


--DE LA FUNCIONES CORRESPONDIENTES A LA SEGUNDA PARTE DEL ENUNCIADO--
serMillonario :: Personaje -> Personaje -> Bool
serMillonario personaje cartman = cantDinero personaje > cantDinero cartman

estarContento :: Personaje -> Int -> Bool
estarContento personaje nivelFelicidadDeseado = nivelFelicidad personaje > nivelFelicidadDeseado

terrancePhillip :: Personaje -> Bool
terrancePhillip personaje = cantDinero personaje > 10


--FUNCIONES OTRAS--
restaSegura :: Int -> Int -> Int
restaSegura x y
    | (x >= y) = (x - y)
    | otherwise = 0

butters = UnPersonaje "Butters" 100 100
stan = UnPersonaje "Stan" 80 17
cartman = UnPersonaje "Cartman" 200 20