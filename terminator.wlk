import bala.*
object terminator{
    var property position=game.at(1,1)

    method image(){
        return "terminator.png"
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