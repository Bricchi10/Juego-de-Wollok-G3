import proyectiles.*
import direcciones.*
import etapaDelJuego.*
class Personaje {
  var property position = game.at(1,1)
  var property vida = 100
  var puedoDisparar = true
  var property balas = 10
  var inmovilizado = false
  var imagenActual = self.spritePasivo() 
  const property proyectilesDisponibles = [self.crearProyectil(), self.crearProyectil(), self.crearProyectil(), self.crearProyectil(), self.crearProyectil(), self.crearProyectil()]

  method image() { 
    return imagenActual
  }

  method mostrarDerrota() { 
    imagenActual = self.spriteMuerte() 
  }

  method mostrarVictoria() { 
    imagenActual = self.spriteVictoria() 
  }

  method inmovilizarPor(milisegundos) {
    inmovilizado = true
    self.mostrarDerrota()
    game.schedule(milisegundos, { self.levantate() } )
  }

  method levantate() {
    inmovilizado = false
    imagenActual = self.spritePasivo()
  }

  method spritePasivo() 
  method spriteAtaque()
  method spriteMuerte()
  method spriteVictoria()
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
    if(not inmovilizado){
       position = moverEnDireccion.siguiente(position.up(1))
    }
  }
  method bajar() {
     if(not inmovilizado){
        position = moverEnDireccion.siguiente(position.down(1))
    }
  }
  
  method disparar() {
    if (not inmovilizado and puedoDisparar and balas > 0) {
      self.dispararProyectil()
    } else {
      game.sound("pinpull.mp3").play()
    }
  }

  method dispararProyectil() {
    puedoDisparar = false
    imagenActual = self.spriteAtaque() //sprite de ataque
    game.sound(self.sonidoDisparo()).play()
    balas -= 1
    self.generaProyectil()
    game.schedule(300, { puedoDisparar = true })
    game.schedule(200, { imagenActual = self.spritePasivo() })
  }

  method generaProyectil() {
    const proyectil = proyectilesDisponibles.first()
    game.addVisual(proyectil)
    proyectil.disparate()
    proyectilesDisponibles.remove(proyectil)
  }

  method agregarProyectilDisponible(proyectil) {
    proyectilesDisponibles.add(proyectil)
  }

  method reiniciarVida(){
    vida = 100
  }

  method mori(){
    etapaDelJuego.perderPartida()
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
  override method spriteVictoria() = "terminatorVictoria.png"
  override method sonidoCarga() = "cs-Recarga.mp3"
  override method imagenCarga() = "municionPickup.png"
  override method crearProyectil() = new Bala(disparador = self) 
  override method sonidoDisparo() = "desert-eagle-cs.mp3"
}
class Spiderman inherits Personaje{
  override method spritePasivo() = "spidermanIdle.png" 
  override method spriteAtaque() = "spidermanDispara.png"
  override method spriteMuerte() = "spidermanCaido.png"
  override method spriteVictoria() = "spidermanVictoria.png"
  override method sonidoCarga() = "comer.mp3"
  override method imagenCarga() = "pizza.png"
  override method crearProyectil() = new Telaraña(disparador = self) 
  override method sonidoDisparo() = "spider-web.mp3"
}
class Goku inherits Personaje{
  override method spritePasivo() = "gokuIdle.png" 
  override method spriteAtaque() = "gokuAtaque.png"
  override method spriteMuerte() = "gokuCaido.png"
  override method spriteVictoria() = "gokuVictoria.png"
  override method sonidoCarga() = "semillaErmitaño.mp3"
  override method imagenCarga() = "semillaErmitaño.png"
  override method crearProyectil() = new Energia(disparador = self) 
  override method sonidoDisparo() = "ki_blast.wav"
}