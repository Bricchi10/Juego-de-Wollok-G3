import proyectiles.*
import direcciones.*
import etapaDelJuego.*
class Personaje{
  var property position=game.at(1,1)
  var property vida = 100
  var puedoDisparar = true 
  var property balas = 10 //nuevo

  method image(){
  }

  method imagenCarga(){
  }

method sonidoCarga() {
  
}
  method mover(direccion) {
    const nuevaPosition = direccion.siguiente(position)
    position = nuevaPosition
  }

  method teHirieron(){
    vida = (vida - 20).max(0)
    game.sound("steveDolor.mp3").play()
    if (vida == 0) {
      self.mori()
    }
  }

  method subir() {
    position = arriba.siguiente(position)
  }
  method bajar() {
    position = abajo.siguiente(position)
  }
  
  method disparar() {
    if (puedoDisparar and balas > 0) {
        puedoDisparar = false
        const proyectil = self.crearProyectil()
        game.sound(self.sonidoDisparo()).play()
        game.addVisual(proyectil)
        proyectil.moverse()
        balas -= 1
        game.schedule(300, { puedoDisparar = true })
    } else {
      game.sound("pinpull.mp3").play()
    }
}

  method reiniciarVida(){
    vida = 100
  }

  method mori(){
    etapaDelJuego.terminar()
  }
   method agarrarCarga(){ //nuevo
    game.colliders(self).forEach({ objeto => 
            objeto.intentarRecargarA(self) 
        })
  }

  method recargar(){
    balas += 5
  }
  method reiniciarBalas(){
    balas= 10
  }
  method crearProyectil() = new Bala(position = self.position().right(1)) 
  method sonidoDisparo() = "desert-eagle-cs.mp3"
}

class Terminator inherits Personaje{
  override method image(){
    return "terminatorDispara.png"
  }
  override method imagenCarga() = "municionPickup.png"
  override method sonidoCarga() = "cs-Recarga.mp3"
}
class Spiderman inherits Personaje{
  override method image(){
    return "spidermanIdle.png"
  }
  override method sonidoCarga() = "comer.mp3"
  override method imagenCarga() = "pizza.png"
  override method crearProyectil() = new Telaraña(position = self.position().right(1)) 
  override method sonidoDisparo() = "spider-web.mp3"
}
class Goku inherits Personaje{
  override method image(){
    return "gokuIdle.png"
  }
  override method sonidoCarga() = "power-up-mario.mp3"
  override method imagenCarga() = "semillaErmitaño.png"
  override method crearProyectil() = new Energia(position = self.position().right(1)) 
  override method sonidoDisparo() = "ki_blast.mp3"
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

object etiquetaDeBalas{
    var personaje = null 
    method personaje(personaje_) { 
      personaje = personaje_ 
    }  
    method position() = game.at(7, 0) 
    method text() = "Balas: " + personaje.balas() 
    method textColor() = "FFFFFFFF" // Blanco 
    
}
