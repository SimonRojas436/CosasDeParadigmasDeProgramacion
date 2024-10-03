data Artista = UnArtista { nombre :: String
                         , canciones :: [Cancion] } deriving (Show)

type Cancion = String

listaDeArtistas :: [Artista]
listaDeArtistas = [fitito, calamardo, paty]

fitito = UnArtista "Fitito Paez" ["11 y 6", "El amor despues del amor", "Mariposa Tecknicolor"]
calamardo = UnArtista "Andres Calamardo" ["Flaca", "Sin Documentos", "Tuyo siempre"]
paty = UnArtista "Taylor Paty" ["Shake It Off", "Lover"]

calificacionCancion :: Cancion -> Int
calificacionCancion = ((+ 10).length.(filter (`elem` ['a'..'z'])))

esExitoso :: Artista -> Bool
esExitoso artista = ((> 50).sum.(filter (> 20)).(map calificacionCancion)) (canciones artista)

artistasExitosos :: [Artista] -> [Artista]
artistasExitosos = filter esExitoso



todoAlMismoTiempo :: [Artista] -> [Artista]
todoAlMismoTiempo listaDeArtistas = filter ((> 50) . sum . (filter (> 20)) . (map ((+ 10).length.(filter (`elem` ['a'..'z']))) XXX)) listaDeArtistas
-------------------------------------------OL-----L---L---------------l-----------------------------------Deberia ser la lista de canciones de un artista----------