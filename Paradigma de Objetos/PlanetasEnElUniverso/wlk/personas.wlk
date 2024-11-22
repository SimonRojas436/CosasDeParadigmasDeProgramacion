import planetas.*


class Persona {
  var property edad
  var property monedas = 20
  var property planeta
  var property oficio = new SinOficio()
  
  method cambiarOficio(nuevoOficio) { oficio = nuevoOficio }

  method esDestacada() = oficio.esDestacada(self)

  method modificarMonedas(cantidadMonedas) { monedas += cantidadMonedas }

  method cumpleanios(unaCantidad) { edad += unaCantidad }

  method trabajarEn(unPlaneta, unTiempo) {
    oficio.trabajarEn(unPlaneta, unTiempo, self)
  }

  method recursos() { oficio.recursos(self) }
}

class SinOficio {
  method recursos(unaPersona) = unaPersona.monedas()
  
  method esDestacada(unaPersona) {
    return unaPersona.edad().between(18, 65) || unaPersona.monedas() > 30
  }
}

class Productor inherits SinOficio {
  const tecnicas = ["cultivo"]

  method cantidadTecnicas() = tecnicas.size()

  method conoce(unaTecnica) = tecnicas.contains(unaTecnica)

  override method recursos(unaPersona) = super(unaPersona) * self.cantidadTecnicas()

  override method esDestacada(unaPersona) {
    return super(unaPersona) || unaPersona.cantidadTecnicas() > 5
  }

  method realizar(unaTecnica, unTiempo, unaPersona) {
    if(unaPersona.conoce(unaTecnica)) unaPersona.modificarMonedas(3 * unTiempo)
    else unaPersona.modificarMonedas(-1)
  }
  
  method aprender(unaTecnica) {
    if(!tecnicas.contains(unaTecnica)) tecnicas.add(unaTecnica)
  }

  method trabajarEn(unPlaneta, unTiempo, unaPersona) {
    if(unaPersona.planeta() == unPlaneta)
      self.realizar(tecnicas.last(), unTiempo, unaPersona)
  }
}

class Constructor {
  var property region
  var property cantidadConstrucciones
  //var property inteligencia

  method recursos(unaPersona) = unaPersona.monedas() + 10 * cantidadConstrucciones

  method esDestacada(unaPersona) {
    return cantidadConstrucciones > 5
  }

  method trabajarEn(unPlaneta, unTiempo, unaPersona) {
    cantidadConstrucciones += 1
    unPlaneta.nuevaConstruccion(region.construir(unTiempo, unaPersona))
    unaPersona.modificarMonedas(-5)
  }
}