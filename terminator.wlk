import bala.*
import direcciones.*
object terminator{
    var property position=game.at(1,1)

    method image(){
        return "terminatorDispara.png"
    }

    method mover(direccion) {
		const nuevaPosition = direccion.siguiente(position)
        position = nuevaPosition
	}
  method teHirieron(){
    
  }

method subir() {
    position = arriba.siguiente(position)
  }
method bajar() {
    position = abajo.siguiente(position)
  }
method irDer() {
   // position = position.right(1)
  }
method irIzq() {
   // position = position.left(1)
  }
  method disparar(){
    const bala=new Bala(position=self.position().right(1))
    game.addVisual(bala)
    bala.moverse()
  }


}