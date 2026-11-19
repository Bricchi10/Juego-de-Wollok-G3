import spawners.*
import etapaDelJuego.*

class BarraVida {
  var property personaje

  method position() = game.at(2,0)
  method image() = (personaje.vida() / 20).stringValue() + "_DeVida.png"
}

object barraDeBalas {
    method position() = game.at(0, 6) 
    method image() = "cartelDeBalas.png"
}

object barraProgreso {
    method position() = game.at(game.width() -6, 0)
    method image() = "BarraProgreso_" + etapaDelJuego.progresoActual() + ".png"
}

class Etiqueta {
  var property personaje
  method position()
  method text() = self.informacionDeseada()
  method textColor() = "FFFFFFFF"

  method informacionDeseada()
}
class EtiquetaVida inherits Etiqueta() {
  override method position()= game.origin()
  override method informacionDeseada() = "Vida:" + personaje.vida()
}
class EtiquetaBalas inherits Etiqueta() {
  override method position() = game.at(1, 6)
  override method informacionDeseada() = "" + personaje.balas()
}

class DefensaArriba {//El aumento de defensa aparece arriba de los afectados
  const property robotAsignado
  method position() = robotAsignado.position()
  method image() = "defensaArriba.png"
  method chocarConPersonaje(personaje) {}
  method teHirieron() {}
  method inmovilizar() {}
}
class TelarañaArriba inherits DefensaArriba { //La telaraña aparece arriba de los afectados
  override method image() = "telarana_arriba.png"
}

object explosion { 
  var property position = game.origin()
  method image() = "explosion_pequeña.png"
  method teHirieron() {}
  method inmovilizar() {}
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