import spawners.*
import proyectiles.*
import direcciones.*
import etapaDelJuego.*
//Superclase Personaje
class Personaje {
  var property position = game.at(1,1)
  var property vida = 100
  var puedoDisparar = true
  var property balas = 10
  var inmovilizado = false
  var imagenActual = personajeActual.spritePasivo()
  const property proyectilesDisponibles = self.proyectilesAReutilizar()
  var property personajeActual
  const levantarse = game.tick(3000, { self.levantate() }, false)
  const terminarDisparo = game.tick(300, { self.terminaAnimacionDisparo() }, false)

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

  method inmovilizar() {
    inmovilizado = true
    self.mostrarDerrota()
    levantarse.start()
  }

  method levantate() {
    inmovilizado = false
    levantarse.stop()
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
    if (puedoDisparar and balas > 0){
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
    const proyectil = proyectilesDisponibles.first()
    spawnerProyectiles.generarProyectil(proyectil)
    proyectilesDisponibles.remove(proyectil)
    terminarDisparo.start()
  }

  method terminaAnimacionDisparo() {
    self.mostrarPasivo()
    puedoDisparar = true
    terminarDisparo.stop()
  }

  method continuarAnimaciones() {
    if (inmovilizado) {
      levantarse.start()
    }
    if (!puedoDisparar) {
      terminarDisparo.start()
    }
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

  method proyectilesAReutilizar() {
    const proyectilesAlMomento = []
    (1..5).forEach({ numero =>
      proyectilesAlMomento.add(new Proyectil(disparador = self, tipoDeProyectil = personajeActual.proyectilAsignado()))
    })
    return proyectilesAlMomento
  }

  method cambiarPersonajeA(personajeNuevo){
    personajeActual = personajeNuevo
    self.mostrarPasivo()
    proyectilesDisponibles.forEach({ proyectil =>
      proyectil.tipoDeProyectil(personajeActual.proyectilAsignado())
    })
  }
  method reiniciar() {
    vida = 100
    balas = 10
    puedoDisparar = true
    inmovilizado = false
    position = game.at(1, 1)
  proyectilesDisponibles.clear()
    (1..5).forEach({ 
      numero => proyectilesDisponibles.add( new Proyectil(disparador = self, 
                                            tipoDeProyectil = personajeActual.proyectilAsignado()) ) })
}
}

//Personajes
object terminator {
  method spritePasivo() = "terminatorIdle.png" 
  method spriteAtaque() = "terminatorDispara.png"
  method spriteMuerte() = "terminatorCaido.png"
  method spriteVictoria() = "terminatorVictoria.png"
  method sonidoCarga() = "cs-Recarga.mp3"
  method imagenCarga() = "municionPickup.png"
  method proyectilAsignado() = new Bala() 
  method sonidoDisparo() = "desert-eagle-cs.mp3"
}
object spiderman {
  method spritePasivo() = "spidermanIdle.png" 
  method spriteAtaque() = "spidermanDispara.png"
  method spriteMuerte() = "spidermanCaido.png"
  method spriteVictoria() = "spidermanVictoria.png"
  method sonidoCarga() = "comer.mp3"
  method imagenCarga() = "pizza.png"
  method proyectilAsignado() = new Telaraña() 
  method sonidoDisparo() = "spider-web.mp3"
}
object goku {
  method spritePasivo() = "gokuIdle.png" 
  method spriteAtaque() = "gokuAtaque.png"
  method spriteMuerte() = "gokuCaido.png"
  method spriteVictoria() = "gokuVictoria.png"
  method sonidoCarga() = "semillaErmitaño.mp3"
  method imagenCarga() = "semillaErmitaño.png"
  method proyectilAsignado() = energia
  method sonidoDisparo() = "ki_blast.wav"
}