object pepita {
  var energy = 100

  method energy() = energy

  method fly(meters) {
    energy = energy - meters * 10
  }

  method isTired() = energy < 20

  method eatFood(food) {
    energy =+ food.energy()
  } 

}

object alpiste {
  method energy() = 5 
}

object apple {
  var maduracion = 0
  var calorias = 50
  
  method energy() = calorias

  method rippen() {
    maduracion += 10
    if(maduracion < 100) calorias = calorias * 1.1
    if(maduracion == 100) calorias = 100
    if(maduracion > 100 and calorias > 0) calorias -= 20
  }
}