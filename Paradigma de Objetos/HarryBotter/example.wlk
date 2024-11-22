
const casasHogwart = [gryffindor, slytherin, ravenclaw, hufflepuff]

class Bot {
  var property cargaElectrica
  var property aceitePuro

  method modificarCargaElectrica(unaCantidad) {
    cargaElectrica -= unaCantidad
  }

  method ensuciar() { aceitePuro = false }

  method anularCargaElectrica() { cargaElectrica = 0 }

  method estaActivo() = cargaElectrica != 0
}

const lordVoldebot = new Bot(cargaElectrica = 1000, aceitePuro = false)

object sombreroSeleccionador inherits Bot(cargaElectrica = 100, aceitePuro = true) {
  var indice = 0

  override method ensuciar() {}

  method asignarCasa(variosIngresantes) {
    variosIngresantes.forEach({ e =>
      const casaAsignada = casasHogwart.get(indice)

      e.casaHogwart(casaAsignada)
      casaAsignada.recibirIntegrante(e)
      self.cambiarIndice()
    })
  }

  method cambiarIndice() {
    if(indice >= 3) indice = 0 else indice += 1
  }
}

class BotEstudiante inherits Bot {
  var property casaHogwart = null
  const property hechizosAprendidos = []

  method cantidadHechizosConocidos() = hechizosAprendidos.size()

  method lanzarHechizo(unHechizo, unaVictima) {
    if(self.conoceHechizo(unHechizo) && self.estaActivo() && unHechizo.condicion(self))
      unHechizo.accion(unaVictima)
  }

  method conoceHechizo(unHechizo) = hechizosAprendidos.contains(unHechizo)

  method esExperimentado() = self.cantidadHechizosConocidos() > 3 && cargaElectrica > 50

  method ultimoHechizoAprendido() = hechizosAprendidos.last()

  method asistirMateria(unaMateria) {
    hechizosAprendidos.add(unaMateria.hechizoAprendido())
  }
}

class BotProfesor inherits BotEstudiante {
  const property materiasDictadas = []

  method cantidadMateriasDictadas() = materiasDictadas.size()

  override method esExperimentado() = super() && self.cantidadMateriasDictadas() >= 2

  override method modificarCargaElectrica(unaCantidad) {}

  override method anularCargaElectrica() {
    cargaElectrica = cargaElectrica.div(2)
  }
}

class Materia {
  const property nombreMateria
  var property profesor
  var property hechizoAprendido

  method enseniar(variosEstudiantes) {
    variosEstudiantes.forEach({ e => e.asistirMateria(self) })
  }
}

class CasaHogwart {
  const property integrantes = #{}
  var property peligrosa = self.esPeligrosa()

  method recibirIntegrante(unIntegrante) = integrantes.add(unIntegrante)

  method cantIntegrantes() = integrantes.size()

  method cantIntegrantesAceiteSucio() = integrantes.count({ i => not(i.aceitePuro()) })

  method esPeligrosa() = self.cantIntegrantesAceiteSucio() == (self.cantIntegrantes().div(2))

  method atacar() {
    integrantes.forEach({ e => e.lanzarHechizo(e.ultimoHechizoAprendido(), lordVoldebot)})
  }
}

const gryffindor = new CasaHogwart(peligrosa = false)

const slytherin = new CasaHogwart(peligrosa = true)

const ravenclaw = new CasaHogwart()

const hufflepuff = new CasaHogwart()

class Hechizo {
  method algo() = 0

  method condicion(unHechicero) {}

  method accion(unaVictima) {
    unaVictima.modificarCargaElectrica(self.algo())
  }
}

object inmobilus inherits Hechizo {
  override method algo() = 50
}

object sectumSempra inherits Hechizo {
  override method condicion(unHechicero) = unHechicero.esExperimentado()

  override method accion(unaVictima) {
    if(unaVictima.aceitePuro()) unaVictima.ensuciar()
  }
}

object avadakedabra inherits Hechizo {
  override method condicion(unHechicero) = not(unHechicero.aceitePuro()) || unHechicero.casaHogwart().peligrosa()

  override method accion(unaVictima) {
    unaVictima.anularCargaElectrica()
  }
}

class HechizoComun inherits Hechizo {
  var property cargaNegativa

  override method algo() = cargaNegativa

  override method condicion(unHechicero) = unHechicero.cargaElectrica() > cargaNegativa

  override method accion(unaVictima) {
    unaVictima.modificarCargaElectrica(cargaNegativa)
  }
}