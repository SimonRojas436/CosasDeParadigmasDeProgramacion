class Persona {
  var property edad
  var property recursos = 20
  var property planeta
  var responsabilidad

  method esDestacado() {
    return ((edad >= 18 && edad <= 30) || recursos > 30)
  }

  method modificarRecursos(cantRecursos) { recursos += cantRecursos }

  method cumpleanios() { edad += 1 }
}

class Murallas {
  var longitud

  method valor() = longitud * 10
}

class Museo {
  var superficie
  var indiceImportancia

  method valor() = superficie * indiceImportancia
}

class Planetas {
  const habitantes = []
  const construcciones = []
  

  method esValioso() {
    construcciones.sum({ c => c.valor() }) > 100
  }

  method delegacionDiplomatica() { 
    return habitantes.filter({ h => (h.esDestacado() || self.habitanteRico()) })
  }

  method habitanteRico() {
    return habitantes.max({ h => h.recursos() })
  }
}



class Productor inherits Persona {
  const tecnicas = ["cultivo"]

  method cantidadTecnicas() = tecnicas.size()

  override method recursos() = super() * self.cantidadTecnicas()

  override method esDestacado() {
    return (super() || self.cantidadTecnicas() > 5)
  }

  method realizar(unaTecnica, unTiempo) {
    if(tecnicas.contains(unaTecnica)) 3 * unTiempo
    else self.modificarRecursos(-1)
  }
  
  method aprender(unaTecnica) {
    if(!tecnicas.contains(unaTecnica)) tecnicas.add(unaTecnica)
  }

  method trabajarEn(unPlaneta, unTiempo) {
    if(planeta == unPlaneta) self.realizar(tecnicas.last(), unTiempo)
  }
}
/*
class Constructor inherits Persona {
  var cantConstrucciones
  var region

  override method recursos() = super() * (10 * )
}*/