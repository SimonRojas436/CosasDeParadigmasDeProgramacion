import wlk.invitados.*
import wlk.disfraces.*


class Fiesta {
  const property lugar
  const property fecha
  const property invitados = #{}

  //PUNTO 2//
  method esUnBodrio() = self.estanTodosDisconformes()

  method estanTodosDisconformes() = invitados.all({ i => not(i.estaConforme()) })

  //PUNTO 3//
  method mejorDisfraz() = self.invitadoConMejorDisfraz().disfraz()

  method invitadoConMejorDisfraz() = invitados.max({ i => i.puntajeDisfraz() })

  //PUNTO 5//
  method agregarInvitado(unInvitado) {
    if(unInvitado.tieneDisfraz() && !self.vinoALaFiesta(unInvitado))
      invitados.add(unInvitado)
    else
      throw new Exception(message = "No se cumplen los requisitos propuestos")
  }
  
  method vinoALaFiesta(unaPersona) = invitados.contains(unaPersona)

  method sonTodosSexies() = invitados.all({ i => i.esSexy() })
}

