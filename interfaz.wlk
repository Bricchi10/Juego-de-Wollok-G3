import etapaDelJuego.*

object barraVida {
  var personaje=null

  method position()= game.at(2,0)
  method personaje(personaje_){
    personaje=personaje_
  }

  method image(){
    return (personaje.vida() / 20).stringValue() + "_DeVida.png"
  }
}
object etiquetaVida {
  var personaje=null
  method personaje(personaje_){
    personaje=personaje_
  }
  method position()= game.at(0,0)
  method text()= "Vida:" + personaje.vida()
  method textColor() = "FFFFFFFF"
}

object etiquetaDeBalas {
    var personaje = null 
    method personaje(personaje_) { 
      personaje = personaje_ 
    }  
    method position() = game.at(0, 6) 
    method text() = "Balas: " + personaje.balas() 
    method textColor() = "FFFFFFFF" // Blanco 
}

object barraProgreso {
    method position() = game.at(game.width() -6, 0)
    method image() = "BarraProgreso_" + etapaDelJuego.progresoActual() + ".png"
}

class DefensaArriba {
  const property robotAsignado
  method position() = robotAsignado.position()
  method image() = "defensaArriba.png"
  method teHirieron(){
    self.mori()
  }
  method chocarConPersonaje(personaje) {
    self.mori()
  }
  method mori() {
    game.sound("muerteRobot.mp3").play()
    game.removeVisual(self)
  }
}