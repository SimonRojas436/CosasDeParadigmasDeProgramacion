import criticas.*


//PLATAFORMA//
object plataforma {
  var property juegos = []

  method modificarDescuento(unJuego, nuevoDescuento) {
    unJuego.descuento(nuevoDescuento)
  }

  method juegoMasCaro() = juegos.max({ j => j.precioBase() })

  method nivelarPrecios(unDescuentoDirecto) {
    if(unDescuentoDirecto > 100)
      throw new Exception(message = "No se puede aplicar un descuento mayor a 100%")
    else {
      const precioJuegoMasCaro = self.juegoMasCaro().precio()
      const juegosADescontar = juegos.filter({ j => j.precio() > (3/4) * precioJuegoMasCaro })
      const descuentoDirecto = new DescuentoDirecto(porcentaje = unDescuentoDirecto)
      
      juegosADescontar.forEach({ j => j.modificarDescuento(j, unDescuentoDirecto)})
    }
  }

  method juegoAptoParaMenoresEnPais(unJuego, unPais) {
    return unJuego.aptoParaMenores(unPais)
  }
  
  method precioJuegoEnPais(unJuego, unPais) = unPais.conversionAMonedaLocal(unJuego)

  method juegosAptosParaMenoresEnPais(unPais) = juegos.filter({ j => self.juegoAptoParaMenoresEnPais(j, unPais) })

  method promedioPrecioFinalJuegosAptosEnPais(unPais) {
    const juegosAptos = self.juegosAptosParaMenoresEnPais(unPais)
    const cantidadJuegos = juegosAptos.size()

    return juegosAptos.sum({ j => self.precioJuegoEnPais(j, unPais) }) / cantidadJuegos
  }

  method hayJuegoGalardonado() {
    return juegos.any({ j => j.noTieneCriticasNegativas() })
  }
}


//DESCUENTOS//
class DescuentoDirecto {
  var property porcentaje

  method aplicar(unJuego) {
    return unJuego.precioBase() * ((porcentaje / 100) + 1)
  }
}

class DescuentoFijo {
  var property montoFijo

  method aplicar(unJuego) {
    const precioFinal = unJuego.precioBase() - montoFijo
    return (precioFinal).max(unJuego.precioBase() / 2)
  }
}

class Gratis {
  method aplicar(unJuego) { return 0 }
}

object descuentoNulo {
  method aplicar(unJuego) = unJuego.precioBase()
}


//JUEGOS//
class Juego {
  const property precioBase
  var property descuento = descuentoNulo
  const property caracteristicas = []
  const property criticas = []

  method precio() = descuento.aplicar(self)

  method agregarCaracteristica(unaCaracteristica) = caracteristicas.add(unaCaracteristica)

  method contieneCaracteristica(unaCaracteristica) = self.caracteristicas().contains(unaCaracteristica)

  method contieneAlgunaCaracteristicaProhibida(variasCaracteristicas) = variasCaracteristicas.any({ c => self.contieneCaracteristica(c) })

  method aptoParaMenores(unPais) = !self.contieneAlgunaCaracteristicaProhibida(unPais.legislacionVigente())

  method recibirCritica(unaCritica) = criticas.add(unaCritica)

  method tieneMasDeNCriticasPositivas(n) = criticas.filter({ c => c.esPositiva() }).size() > n

  method noTieneCriticasNegativas() = criticas.all({ c => c.esPositiva() })

  method tieneCriticoLiterario() = criticas.any({ c => c.textoCritico().size() > 100 })
}

class Pais {
  var property conversion
  var property legislacionVigente = []

  method conversionAMonedaLocal(unJuego) = unJuego.precio() * conversion
}