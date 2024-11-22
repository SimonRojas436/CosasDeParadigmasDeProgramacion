import wlk.fiesta.*
import wlk.disfraces.*


class Invitado {
  var property edad
  var property disfraz
  var property personalidad

  method tieneDisfraz() = disfraz != null

  method cambiarDisfraz(nuevoDisfraz) {
    disfraz = nuevoDisfraz
  }

  method esSexy() = personalidad.esSexy(self)

  method estaConforme() = disfraz.puntaje(self) > 10 && self.condicionAdicionalDeConformidad()

  method condicionAdicionalDeConformidad()

  method puntajeDisfraz() = disfraz.puntaje(self)
}

//TIPOS//
class Caprichosos inherits Invitado {
  override method condicionAdicionalDeConformidad() = disfraz.nombre().length().even()
}

class Pretenciosos inherits Invitado {
  override method condicionAdicionalDeConformidad() = ((new Date()).minusDays(disfraz.fechaConfeccion())).day() < 30
}

class Numerologos inherits Invitado {
  var property cifraAncestral

  method cambiarCifraAncestral(nuevaCifraAncestral) {
    cifraAncestral = nuevaCifraAncestral
  }

  override method condicionAdicionalDeConformidad() = disfraz.puntaje(self) == cifraAncestral
}

//PERSONALIDADES//
object alegre {
  method esSexy(unaPersona) = false
}

object taciturna {
  method esSexy(unaPersona) = unaPersona.edad() < 30
}

object cambiante {
  const property personalidades = [alegre, taciturna]

  method esSexy(unInvitado) = personalidades.anyOne().esSexy(unInvitado)
}