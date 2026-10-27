import proyectiles.*
import direcciones.*
import etapaDelJuego.*
class Personaje{
  var property position = game.at(1,1)
  var property vida = 100
  var puedoDisparar = true
  var property balas = 10
  var imagenActual = self.spritePasivo() 

  method image() { 
    return imagenActual
  }

  method mostrarDerrota() { 
    imagenActual = self.spriteMuerte() 
  }

  method spritePasivo() 
  method spriteAtaque()
  method spriteMuerte()
  method imagenCarga()
  method sonidoCarga()
  method crearProyectil()
  method sonidoDisparo()
  
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
        imagenActual = self.spriteAtaque() //sprite de ataque
        const proyectil = self.crearProyectil()
        game.sound(self.sonidoDisparo()).play()
        game.addVisual(proyectil)
        proyectil.moverse()
        balas -= 1
        game.schedule(300, { puedoDisparar = true })
        game.schedule(200, { imagenActual = self.spritePasivo() })
    } else {
      game.sound("pinpull.mp3").play()
    }
  }

  method reiniciarVida(){
    vida = 100
  }

  method mori(){
    etapaDelJuego.terminarDerrota()
  }

  method agarrarCarga(){
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
}

class Terminator inherits Personaje{
  override method spritePasivo() = "terminatorIdle.png" 
  override method spriteAtaque() = "terminatorDispara.png"
  override method spriteMuerte() = "terminatorCaido.png"
  override method sonidoCarga() = "cs-Recarga.mp3"
  override method imagenCarga() = "municionPickup.png"
  override method crearProyectil() = new Bala(position = self.position().right(1)) 
  override method sonidoDisparo() = "desert-eagle-cs.mp3"
}
class Spiderman inherits Personaje{
  override method spritePasivo() = "spidermanIdle.png" 
  override method spriteAtaque() = "spidermanDispara.png"
  override method spriteMuerte() = "spidermanCaido.png"
  override method sonidoCarga() = "comer.mp3"
  override method imagenCarga() = "pizza.png"
  override method crearProyectil() = new Telaraña(position = self.position().right(1)) 
  override method sonidoDisparo() = "spider-web.mp3"
}
class Goku inherits Personaje{
  override method spritePasivo() = "gokuIdle.png" 
  override method spriteAtaque() = "gokuAtaque.png"
  override method spriteMuerte() = "gokuCaido.png"
  override method sonidoCarga() = "semillaErmitaño.mp3"
  override method imagenCarga() = "semillaErmitaño.png"
  override method crearProyectil() = new Energia(position = self.position().right(1)) 
  override method sonidoDisparo() = "ki_blast.wav"
}