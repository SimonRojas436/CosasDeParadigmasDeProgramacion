import wlk.fiesta.*
import wlk.invitados.*


class Disfraz {
  const property nombre
  const property fechaConfeccion
  const property caracteristicas = #{}

  method agregarCaracteristica(unaCaracteristica) {
    caracteristicas.add(unaCaracteristica)
  }

  //PUNTO 1//
  method puntaje(unInvitado) {
    return caracteristicas.sum({ c => c.puntuacion(unInvitado) })
  }
}

//CARACTERÍSTICAS//
class Gracioso {
  var property nivelGracia

  method puntuacion(unInvitado) {
    return if(unInvitado.edad() > 50) (nivelGracia * 3) else nivelGracia
  }
}

class Tobara {
  const property fechaCompra

  method puntuacion(unInvitado) {
    return if(self.fueCompradoConAnticipacion()) 5 else 3
  }

  method fueCompradoConAnticipacion() = ((new Date()).minusDays(fechaCompra)).day() >= 2
}

class Careta {
  //const property personaje
  const property valor

  method puuntuacion(unInvitado) = valor
}

const mickeyMouse = new Careta(valor = 8)
const osoCarolina = new Careta(valor = 6)

object sexy {
  method puntuacion(unInvitado) {
    return if(unInvitado.esSexy()) 15 else 2
  }
}