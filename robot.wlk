object robot{
    var property position=game.at(10,5)
    var fuerza=10

    method image(){
        return "robot.png"
    }
    method mover(direccion) {
		const nuevaPosition = direccion.siguiente(position)
    position = nuevaPosition
	}

method subir() {
   
  }
method bajar() {
   
  }
method irDer() {
    position = position.right(1)
  }
method irIzq() {
    position = position.left(1)
  }

method atacar(){

}

}