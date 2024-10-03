pesoPino :: Float -> Float
pesoPino altura = ((primerosMetros altura) * 300) + ((otrosMetros (altura - 3) * 200))

primerosMetros :: Float -> Float
primerosMetros altura = min altura 3

otrosMetros :: Float -> Float
otrosMetros restanteAltura = max restanteAltura 0

esPesoUtil :: Float -> Bool
esPesoUtil peso = (peso > 400) && (peso < 1000)

sirvePino :: Float -> Bool
sirvePino altura = esPesoUtil (pesoPino altura)