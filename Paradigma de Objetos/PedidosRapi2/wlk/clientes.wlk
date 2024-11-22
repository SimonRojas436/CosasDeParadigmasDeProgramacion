import compras.*


class Cliente {
  const property nombreYApellido
  const property dni
  const property historialCompras = []
  var property tipo = comun

  method comprar(unPedido) {
    if(unPedido.local().tieneProductosDisponibles(unPedido.items())) {
      const compra = new Compra(pedido = unPedido, valorEnvio = unPedido.costoAbonarEnvio(self), fecha = new Date())
      historialCompras.add(compra)
    }
    else
      throw new Exception (message = "El local no cuenta con los productos solicitados.")
  }

  method cambiarTipo(nuevoTipo) { tipo = nuevoTipo }

  method compraMasCara() {
    historialCompras.max({ c => c.precioNeto(self) })
  }
}

class Tipo {
  var property descuentoEnvio
}

const comun = new Tipo(descuentoEnvio = 1)

const silver = new Tipo(descuentoEnvio = 0.5)

class Gold inherits Tipo {
  var property cantidadCompras = 0

  override method descuentoEnvio() = if(!self.envioGratis()) 0.1 else 0

  method envioGratis() {
    return (cantidadCompras % 5) == 0
  }
}