import bala.*
class Personaje{
    var property position=game.at(1,1)

    method image(){
    }

    method mover(direccion) {
		const nuevaPosition = direccion.siguiente(position)
        position = nuevaPosition
	}
  method teHirieron(){
    
  }

method subir() {
    position = position.up(1)
  }
method bajar() {
    position = position.down(1)
  }
method irDer() {
   // position = position.right(1)
  }
method irIzq() {
   // position = position.left(1)
  }
  method disparar(){
    const bala=new Bala(position=self.position())
    game.addVisual(bala)
    bala.moverse()
  }

  method esEnemigo() = false
}

class Terminator inherits Personaje{
  override method image(){
    return "terminator.png"
  }
}