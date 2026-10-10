import wollok.game.*
import robot.*
import personajes.*
import bala.*
import activador.*

object etapaDelJuego { 
  var finalizado = false 
  const personajePrincipal = new Terminator() //Personaje
  const aparecenRobots = game.tick(4000, { self.generarRobots() }, false)
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
    spawnerRobots.generarRobot(new Robot(position = game.at(9, (1 .. 5).anyOne())))
    spawnerRobots.generarRobot(new RobotFuerte(position = game.at(9, (1 .. 5).anyOne())  ))
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
      //muevenRobots.stop()
      ganarJuego.stop()
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
    barraVida.personaje(personajePrincipal)//nuevo
    game.addVisual(barraVida)
    etiquetaVida.personaje(personajePrincipal)//nuevo
    game.addVisual(etiquetaVida)
    activadoresCasa.forEach { activadorCasa => game.addVisual(activadorCasa) }
    personajePrincipal.reiniciarVida()
    
    game.onCollideDo(personajePrincipal, { enemigo =>
      personajePrincipal.teHirieron()
      enemigo.mori()
    })

    activadoresCasa.forEach { activadorCasa => self.perderAlRobotColisionarCon(activadorCasa) }

    //Teclas
	keyboard.up().onPressDo({personajePrincipal.subir()})
	keyboard.down().onPressDo({personajePrincipal.bajar()})
    keyboard.d().onPressDo({personajePrincipal.disparar()})

    //Eventos en relacion al tiempo
    aparecenRobots.start()
    //muevenRobots.start()
    ganarJuego.start()
  }

  method perderAlRobotColisionarCon(activador) {
    game.onCollideDo(activador, { robot =>
      self.terminar()
      robot.mori()
    })
  }
}
object cartelReiniciar { 
    method position() = game.at(5, 2) 
    method image() = "cartelDeReinicio.png"
}