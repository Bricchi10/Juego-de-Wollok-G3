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
  method chocarConPersonaje(personaje) {}
}

object cartelReiniciar { 
  method position() = game.at(5, 2) 
  method image() = "cartelDeReinicio.png"
}

object cartelGameOver{
  method position() = game.at(3,2)
  method image()="game_over_re4_transparente.png"
}

object cartelVictoria{
  method position() = game.at(3,2)
  method image()="cartel_victoria.png"
}