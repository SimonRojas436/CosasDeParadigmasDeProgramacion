import personas.*


class Planeta {
  const habitantes = #{}
  const construcciones = []
  
  method aniadirHabitante(unaPersona) = habitantes.add(unaPersona)

  method esValioso() = construcciones.sum({ c => c.valor() }) > 100

  method delegacionDiplomatica() = (self.habitantesDestacados() + [self.habitanteMasRico()]).asSet()

  method habitantesDestacados() = habitantes.filter({ p => p.esDestacada() })

  method habitanteMasRico() {
    return habitantes.max({ p => p.monedas() })
  }

  method nuevaConstruccion(unaConstruccion) {
    construcciones.add(unaConstruccion)
  }

  method trabajoDelegacion(unTiempo) {
    self.trabajoDelegacion(self, unTiempo)
  }

  method invadir(unPlaneta, unTiempo) {
    self.trabajoDelegacion(unPlaneta, unTiempo)
  }

  method trabajoDelegacion(unPlaneta, unTiempo) {
    self.delegacionDiplomatica().forEach({ h => h.trabajarEn(unPlaneta, unTiempo) })
  }
}

class Muralla {
  var property longitud
  
  method valor() = longitud * 10
}

class Museo {
  var property superficie
  var property indiceImportancia

  method valor() = superficie * indiceImportancia
}

object montania {
  method construir(unTimepo, unConstructor) = new Muralla(longitud = unTimepo / 2)
}

object costa {
  method construir(unTiempo, unConstructor) = new Museo(superficie = unTiempo, indiceImportancia = 1)
}

object llanura {
  method construir(unTiempo, unConstructor) =
    if(unConstructor.esDestacada())
      new Muralla(longitud = unTiempo / 2)
    else
      new Museo(superficie = unTiempo, indiceImportancia = self.proporcional(unConstructor.recursos()))
  
  method proporcional(unMonto) = (unMonto / 100).floor().min(5).max(1)
}