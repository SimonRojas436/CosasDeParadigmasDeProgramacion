cantidadEmpleados nombreEmpresa
    | nombreEmpresa == "Acme" = 10
    | last nombreEmpresa < head nombreEmpresa = cantLetrasIntermedias nombreEmpresa
    | (esCapicua nombreEmpresa) && (esPar (length nombreEmpresa)) == True = (cantLetrasIntermedias nombreEmpresa) * 2
    | (esDivisiblePorTres (length nombreEmpresa)) || (esDivisiblePorSiete (length nombreEmpresa)) == True = 3
    | otherwise = 0

cantLetrasIntermedias x = (length x) - 2
esCapicua x = (reverse x) == x
esPar x = (mod x 2) == 0
esDivisiblePorTres x = (mod x 3) == 0
esDivisiblePorSiete x = (mod x 7) == 0