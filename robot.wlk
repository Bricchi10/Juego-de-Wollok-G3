object robot{

var position = game.origin()
     method position() { 
		return game.center()
	}
    method image(){
        return "robot.png"
    }
    method mover(direccion) {
		const nuevaPosition = direccion.siguiente(position) 
		position = nuevaPosition
	}
    method elementosEnMiPosicion(){
        return game.colliders(self)
    }

}