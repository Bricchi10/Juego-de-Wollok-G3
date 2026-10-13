import wollok.game.*
import robot.*
import personajes.*
import bala.*
import activador.*

object etapaDelJuego { 
  var finalizado = false 
  const personajePrincipal = new Terminator() //Personaje
  const aparecenRobots = game.tick(4000, { self.generarRobots() }, false)
  const apareceMunicion = game.tick(12000, { self.generarMunicionDePersonaje() }, false)//nuevo
  const ganarJuego = game.tick(180000,  { self.ganarPartida() }, false)
  const activadoresCasa = [self.activadorEnY(1), self.activadorEnY(2), self.activadorEnY(3), self.activadorEnY(4), self.activadorEnY(5)]
  
  method activadorEnY(posicionY) {
    return new Activador(position = game.at(0,posicionY))
  }

  method ganarPartida() {
    game.say(personajePrincipal, "¡Gane!")
    game.schedule(1000, { game.stop() })
  }

  method generarRobots() {
    spawnerRobots.generarRobot()
  }
  
  method position() = game.at(3, 2)

  method image(){
    return "game_over_re4_transparente.png"
  }

  method terminar() { 
    if (not finalizado) { 
      finalizado = true 
      game.clear()
      aparecenRobots.stop()
      ganarJuego.stop()
      apareceMunicion.stop()
      spawnerRobots.limpiarRobots()
      game.addVisual(self)
      game.sound("game-over.mp3").play()
      game.addVisual(cartelReiniciar)
      keyboard.r().onPressDo({ self.reiniciar() }) 
    }
  }

  method reiniciar() { 
    finalizado = false
    game.clear()
    self.iniciarPartida() 
  }

  method iniciarPartida(){
    game.addVisual(personajePrincipal)
    barraVida.personaje(personajePrincipal)
    game.addVisual(barraVida)
    etiquetaVida.personaje(personajePrincipal)
    game.addVisual(etiquetaVida)
    etiquetaMunicion.personaje(personajePrincipal)
    game.addVisual(etiquetaMunicion)
    activadoresCasa.forEach { activadorCasa => game.addVisual(activadorCasa) }
    personajePrincipal.reiniciarVida()
    
    game.onCollideDo(personajePrincipal, { enemigo =>
      self.personajePrincipalRecibeDañoDe(enemigo)
    })

    activadoresCasa.forEach { activadorCasa => self.perderAlRobotColisionarCon(activadorCasa) }

    //Teclas
	keyboard.up().onPressDo({personajePrincipal.subir()})
	keyboard.down().onPressDo({personajePrincipal.bajar()})
  keyboard.d().onPressDo({personajePrincipal.disparar()})

    //Eventos en relacion al tiempo
    aparecenRobots.start()
    ganarJuego.start()
    apareceMunicion.start()
  }

  method perderAlRobotColisionarCon(activador) {
    game.onCollideDo(activador, { robot =>
      self.terminar()
      robot.mori()
    })
  }

  method personajePrincipalRecibeDañoDe(enemigo) {
    personajePrincipal.teHirieron()
    enemigo.mori()
  }

  method llegaALaCasa(enemigo) {
    self.terminar()
    enemigo.mori()
  }
}
object cartelReiniciar { 
    method position() = game.at(5, 2) 
    method image() = "cartelDeReinicio.png"
}