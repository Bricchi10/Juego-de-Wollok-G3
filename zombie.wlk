object zombie_Simple {
  const energy = 100
   var property position = null 
  

  method energy() = energy

  method image() = "zombie_comun.png"

method mover(direccion) {
		const nuevaPosition = direccion.siguiente(position)
    position = nuevaPosition
	}

method subir() {
    position = position.up(0.5)
  }
method bajar() {
    position = position.down(0.5)
  }
method irDer() {
    position = position.right(0.5)
  }
method irIzq() {
    position = position.left(0.5)
  }

}
