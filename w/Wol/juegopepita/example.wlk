object pepita {
  var energia = 100
  var position = game.at(1, 8)

  method image() = "f.png"

  method position() = position

  method position(newPos) {
    self.volar(1)
    position = newPos
  }

  method energia() = energia

  method volar(metros) {
    energia = energia - metros * 10
  }

  method estaCansada() = energia < 20

  method come(comida) {
    energia =+ comida.energia()
  }

  method name() {
    
  }
}

object manzana {
  method energia() = 10
  const position = game.at(90, 1)
  
  method position() = position

  method image() = "manzana.png"
}

object alpiste {
  method energia() = 5
  const position = game.at(40, 1)
  
  method position() = position

  method image() = "alpiste.png"
}

object nido {
  const position = game.at(150, 1)

  method position() = position

  method image() = "nido.png"
}