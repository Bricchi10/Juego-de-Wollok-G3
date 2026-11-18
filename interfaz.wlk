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

object barraDeBalas {
    method position() = game.at(0, 6) 
    method image() = "cartelDeBalas.png"
}
object etiquetaDeBalas {
  var personaje = null 
    method personaje(personaje_) { 
      personaje = personaje_ 
    }
  method position() = game.at(1, 6)   
  method text() = "" + personaje.balas()
  method textColor() = "FFFFFFFF"
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
  method teHirieron() {}
  method inmovilizarPor(cantidad) {}
}
class TelarañaArriba inherits DefensaArriba {
  override method image() = "telarana_arriba.png"
}

object explosion { 
  var property position = game.origin()
  method image() = "explosion_pequeña.png"
  method teHirieron() {}
  method inmovilizarPor(cantidad) {}
  method esfumate() {
    game.schedule(1000, { game.removeVisual(self) })
  }
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
object cartelPausa {  
  method image() = "cartelPausa.png"    
  method position() = game.at(4,1)
}
object iluminacion {  
  var property frameActual = 0
  method image() = "Iluminacion_" + frameActual + ".png"
  method position() = game.origin()
  const animacion = game.tick(500, { self.avanzaFrame() }, false)
  method teHirieron() {}
  method avanzaFrame() {
      if (frameActual == 3) {
          animacion.stop()
          game.removeVisual(self)
      }
      frameActual += 1
  }
  method ilumina() {
    game.addVisual(self)
    self.frameActual(0)
    animacion.start()
  }
  method inmovilizar() {}
}
