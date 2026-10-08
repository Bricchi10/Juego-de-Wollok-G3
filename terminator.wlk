import bala.*
import direcciones.*
import etapaDelJuego.*
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
    etapaDelJuego.terminar()
  }
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
    game.sound("desert-eagle-cs.mp3").play()
    game.addVisual(bala)
    bala.moverse()
  }

  method esEnemigo() = false

  method reiniciarVida(){
    vida = 100
  }
}

class Terminator inherits Personaje{
  override method image(){
    return "terminatorDispara.png"
  }
}

object barraVida {
  var personaje=null

  method position()= game.at(2,0)
  method personaje(personaje_){
    personaje=personaje_
  }

  method image(){
    const vidaActual = personaje.vida()
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
  var personaje=null
  method personaje(personaje_){
    personaje=personaje_
  }
  method position()= game.at(0,0)
  method text()= "Vida:" + personaje.vida()
  method textColor() = "FFFFFFFF"
  method esEnemigo() = false
}
