import direcciones.*
object robot{
    var property position=game.at(10,5)
    var fuerza=10
    var vida=100

    method vida(){
      return vida
    }
    method image(){
        return "robot.png"
    }
    method mover(direccion) {
		const nuevaPosition = direccion.siguiente(position)
    position = nuevaPosition
	}
  method teHirieron(){
    vida=vida-10
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

class RobotNormal{
    var property position = game.at( 10, 2) //esto luego deberia cambiar para aparecer en celdas distintas

    method image(){
        return "robot.png"
    }

    method mueveIzquierda(){
        const nuevaPosicion = izquierda.siguiente( self.position())
        position = nuevaPosicion
    } 
}
