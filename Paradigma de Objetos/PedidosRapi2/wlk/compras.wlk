import clientes.*


class Local {
  const property productos = []

  method tieneProductosDisponibles(productosPedidos) {
    productosPedidos.all({ pd => productos.contais(pd) })
  }
}

class Compra {
  const property pedido
  var property valorEnvio
  const property fecha

  method precioNeto(unCliente) = pedido.precioBruto() + valorEnvio
}

class Pedido {
  const property items = #{}
  const property local

  method agregarProducto(unProducto) = items.add(unProducto)

  method precioBruto() = items.sum({ i => i.precioItem() })

  method costoRealEnvio(unCliente) = (calculadorCuadras.distancia(unCliente, local) * 15).min(300)

  method costoAbonarEnvio(unCliente) = self.costoRealEnvio(unCliente) * unCliente.tipo().descuentoEnvio()

  method agregarAlPedido(unProducto, unaCantidad) {
    const itemExistente = items.findOrDefault({ i => i.producto() == unProducto }, null)

    if(itemExistente != null)
      itemExistente.agregarCantidad(unaCantidad)
    else
      items.add(new Item(producto = unProducto, cantidadSolicitada = unaCantidad))
  }
}

class Item {
  const property producto
  var property cantidadSolicitada

  method agregarCantidad(unaCantidad) {
    cantidadSolicitada += unaCantidad
  }

  method precioItem() = producto.precioUnitario() * self.cantidadSolicitada()
}

class Producto {
  const property precioUnitario
}

object calculadorCuadras {
  method distancia(unCliente, unLocal) = 1
}