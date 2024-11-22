cantDias :: Int -> Int
cantDias anio
    | esBisiesto anio == True = 366
    | otherwise = 365

esBisiesto :: Int -> Bool
esBisiesto anio = (esMultiploDe 400 anio) || ((esMultiploDe 4 anio) && ((esMultiploDe 100 anio) == False))

esMultiploDe :: Int -> Int -> Bool
esMultiploDe x y = ((mod y x) ==  0)