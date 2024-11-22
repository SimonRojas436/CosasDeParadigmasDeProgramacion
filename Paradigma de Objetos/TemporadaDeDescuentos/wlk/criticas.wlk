import plataforma.*


//CRITICAS//
class Critica {
	var property textoCritico
	var property positiva

	method esPositiva() = positiva
}

object positiva {
  method textoUsuario() = "SI"
  method esPositiva() = true
}

object negativa {
  method textoUsuario() = "NO"
  method esPositiva() = false
}


//CRITICOS//
class Critico {
  method critica()

  method haceUnaCriticaPositiva(unJuego)

  method hacerCritica(unJuego) {
    const unaCritica = new Critica(textoCritico = self.critica(), positiva = self.haceUnaCriticaPositiva(unJuego))
    
    unJuego.recibirCritica()
  }
}

class Usuario inherits Critico {
  var property textoCritico

  override method critica() = textoCritico.textoUsuario()

  override method haceUnaCriticaPositiva(unJuego) = textoCritico.esPositiva()
}

class CriticoPago inherits Critico {
  var property juegosQueLePagaron = []
  const property textoCritico = ["Malísimo", "Buenísimo", "Asqueroso"]

  override method critica() = textoCritico.anyOne()

  override method haceUnaCriticaPositiva(unJuego) = juegosQueLePagaron.contains(unJuego)

  method recibirPagoDeJuego(unJuego) = juegosQueLePagaron.add(unJuego)

  method dejarDeRecibirPagoDeJuego(unJuego) = juegosQueLePagaron.remove(unJuego)
}

class Revistas inherits Critico {
  var property criticos = []

  override method haceUnaCriticaPositiva(unJuego) {
    return self.mayoriaHaceUnaCriticaPositiva(unJuego)
  }

  method mayoriaHaceUnaCriticaPositiva(unJuego) {
    const criticosQueHacenCriticasPositivas = self.criticosQueHacenCriticasPositivas(unJuego)

    return criticosQueHacenCriticasPositivas.size() > (criticos / 2)
  }

  method criticosQueHacenCriticasPositivas(unJuego) {
    return criticos.filter({ c => c.haceUnaCriticaPositiva(unJuego) })
  }

  override method critica() = criticos.map({ c => c.critica() })

  method incorporarCritico(unCritico) = criticos.add(unCritico)

  method sacarCritico(unCritico) = criticos.remove(unCritico)
}