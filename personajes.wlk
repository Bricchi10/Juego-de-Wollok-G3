import proyectiles.*
import direcciones.*
import etapaDelJuego.*
class Personaje {
  var property position = game.at(1,1)
  var property vida = 100
  var puedoDisparar = true
  var property balas = 10
  var inmovilizado = false
  var imagenActual = personajeActual.spritePasivo()
  var property proyectilesDisponibles = self.proyectilesAReutilizar()
  var property personajeActual

  method image() { 
    return imagenActual
  }

  method mostrarDerrota() { 
    imagenActual = personajeActual.spriteMuerte() 
  }

  method mostrarVictoria() { 
    imagenActual = personajeActual.spriteVictoria() 
  }

  method mostrarPasivo() { 
    imagenActual = personajeActual.spritePasivo() 
  }

  method inmovilizarPor(milisegundos) {
    inmovilizado = true
    self.mostrarDerrota()
    game.schedule(milisegundos, { self.levantate() } )
  }

  method levantate() {
    inmovilizado = false
    self.mostrarPasivo()
  }

  method imagenCarga() = personajeActual.imagenCarga()
  method sonidoCarga() = personajeActual.sonidoCarga()
  
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
    imagenActual = personajeActual.spriteAtaque() //sprite de ataque
    game.sound(personajeActual.sonidoDisparo()).play()
    balas -= 1
    self.generaProyectil()
    game.schedule(300, { puedoDisparar = true })
    game.schedule(200, { self.mostrarPasivo() })
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

  method proyectilesAReutilizar() = [personajeActual.crearProyectil(), personajeActual.crearProyectil(), personajeActual.crearProyectil(), personajeActual.crearProyectil(), personajeActual.crearProyectil(), personajeActual.crearProyectil()]

  method cambiarPersonajeA(personajeNuevo){
    personajeActual = personajeNuevo
    proyectilesDisponibles.clear()
    proyectilesDisponibles.addAll(self.proyectilesAReutilizar())
    self.mostrarPasivo()
  }
}

object terminator {
  method spritePasivo() = "terminatorIdle.png" 
  method spriteAtaque() = "terminatorDispara.png"
  method spriteMuerte() = "terminatorCaido.png"
  method spriteVictoria() = "terminatorVictoria.png"
  method sonidoCarga() = "cs-Recarga.mp3"
  method imagenCarga() = "municionPickup.png"
  method crearProyectil() = new Bala(disparador = etapaDelJuego.protagonista()) 
  method sonidoDisparo() = "desert-eagle-cs.mp3"
}
object spiderman {
  method spritePasivo() = "spidermanIdle.png" 
  method spriteAtaque() = "spidermanDispara.png"
  method spriteMuerte() = "spidermanCaido.png"
  method spriteVictoria() = "spidermanVictoria.png"
  method sonidoCarga() = "comer.mp3"
  method imagenCarga() = "pizza.png"
  method crearProyectil() = new Telaraña(disparador = etapaDelJuego.protagonista()) 
  method sonidoDisparo() = "spider-web.mp3"
}
object goku {
  method spritePasivo() = "gokuIdle.png" 
  method spriteAtaque() = "gokuAtaque.png"
  method spriteMuerte() = "gokuCaido.png"
  method spriteVictoria() = "gokuVictoria.png"
  method sonidoCarga() = "semillaErmitaño.mp3"
  method imagenCarga() = "semillaErmitaño.png"
  method crearProyectil() = new Energia(disparador = etapaDelJuego.protagonista()) 
  method sonidoDisparo() = "ki_blast.wav"
}