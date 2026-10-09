import wollok.game.*
import robot.*
import terminator.*
import bala.*
object etapaDelJuego { 
  var finalizado = false 
  const personajePrincipal= new Terminator() //Personaje
  const aparecenRobots = game.tick(4000, { spawnerRobots.generarRobot(new Robot(position = game.at(9, (1 .. 5).anyOne())  )) spawnerRobots.generarRobot(new RobotFuerte(position = game.at(9, (1 .. 5).anyOne())  ))}, false)
  const ganarJuego = game.tick(180000,  { game.say(personajePrincipal, "¡Gane!") game.schedule(1000, { game.stop() }) }, false)
  
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
    personajePrincipal.reiniciarVida()
    
    game.onCollideDo(personajePrincipal, { elemento => if (elemento.esEnemigo() ){ 
        personajePrincipal.recibirDaño(20) 
        spawnerRobots.eliminarRobot(elemento) 
        } 
    })

    //Teclas
	  keyboard.up().onPressDo({personajePrincipal.subir()})
	  keyboard.down().onPressDo({personajePrincipal.bajar()})
    keyboard.d().onPressDo({personajePrincipal.disparar()})

    //Eventos en relacion al tiempo
    aparecenRobots.start()
    ganarJuego.start()
  }
}
object cartelReiniciar { 
    method position() = game.at(5, 2) 
    method image() = "cartelDeReinicio.png"
}