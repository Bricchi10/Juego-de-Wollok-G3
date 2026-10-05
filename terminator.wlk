import bala.*
class Personaje{
    var property position=game.at(1,1)
    var property vida = 100

    method image(){
    }

    method mover(direccion) {
		const nuevaPosition = direccion.siguiente(position)
        position = nuevaPosition
	}

method recibirDaño(cantidad) {
  vida = (vida - cantidad).max(0)
  game.sound("steveDolor.mp3").play()
  if (vida == 0) {
    juego.terminar()
  }
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
    const bala=new Bala(position=self.position().right(1))
    game.sound("desert-eagle-cs.mp3").play()
    game.addVisual(bala)
    bala.moverse()
  }

  method esEnemigo() = false
}

class Terminator inherits Personaje{
  override method image(){
    return "terminator.png"
object barraVida {
  method position()= game.at(2,0)
  method image(){
    const vidaActual = terminator.vida()
    return if (vidaActual == 100) "5Corazones.png"
           else if (vidaActual >= 80) "4Corazones.png"
           else if (vidaActual >= 60 ) "3Corazones.png"
           else if (vidaActual  >= 40) "2Corazones.png"
           else if (vidaActual >= 20) "1Corazon.png"
           else "CorazonVacio.png"
  }
  method esEnemigo() = false
}
object etiquetaVida {
  method position()= game.at(0,0)

  method text()= "Vida:" + terminator.vida()
  method textColor() = "FFFFFFFF"
  method esEnemigo() = false
}
object juego { 
  var finalizado = false 
  
  method position() = game.at(3, 2)
  method image(){
    return "game_over_re4_transparente.png"
  }
  method terminar() { 
    if (not finalizado) { 
      finalizado = true 
      game.clear()
      game.addVisual(self)
      game.sound("game-over.mp3").play()
    }
  }
}