import wollok.game.*
import robot.*
import personajes.*
import proyectiles.*
import activador.*

object etapaDelJuego { 
  var finalizado = false 
  var property personajePrincipal = new Terminator() //Personaje
  const musicaFondoInicio = game.sound("cs-1-6-music-lobbys.mp3")
  const aparecenRobots = game.tick(4000, { self.generarRobots() }, false)
  const apareceMunicion = game.tick(12000, { self.generarMunicionDePersonaje() }, false)//nuevo
  const ganarJuego = game.tick(180000,  { self.ganarPartida() }, false)
  const activadoresCasa = [self.activadorEnY(1), self.activadorEnY(2), self.activadorEnY(3), self.activadorEnY(4), self.activadorEnY(5)]
  const musicaDeFondo = game.sound("musicaNivel.mp3")
  const sonidoDeGameOver = game.sound("game-over.mp3")
  
  method menuInicio(){
      game.clear()
      self.selTerminator()
      game.addVisual(fondo)
      musicaFondoInicio.shouldLoop(true)
      game.schedule(500, { musicaFondoInicio.play()} )

      keyboard.space().onPressDo({self.iniciarPartida()})
      keyboard.i().onPressDo({self.menuIstrucciones()})
      keyboard.num1().onPressDo({self.selTerminator()})
      keyboard.num2().onPressDo({self.selSpiderman()})
      keyboard.num3().onPressDo({self.selWolverine()})
  }
  method selTerminator()  {
 personajePrincipal = new Terminator()
 fondo.image("menu_personajes_1_terminator.png")
}

method selSpiderman(){
   personajePrincipal = new Spiderman()
fondo.image("menu_personajes_2_spiderman.png")
}

method selWolverine(){
   personajePrincipal = new Goku()
fondo.image("menu_personajes_3_goku.png")
}


  method menuIstrucciones(){
    game.boardGround()
    keyboard.b().onPressDo({self.menuInicio()})
  }
  
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

  method generarMunicionDePersonaje() { //nuevo
    spawnerMunicion.generarMunicion()
  }
  
  method position() = game.at(3, 2)

  method image(){
    return "game_over_re4_transparente.png"
  }

  method terminar() { 
    if (not finalizado) { 
      finalizado = true 
      game.clear()
      game.addVisual(fondo)
      fondo.image("Fondo.jpg")
      aparecenRobots.stop()
      apareceMunicion.stop()//nuevo
      ganarJuego.stop()
      apareceMunicion.stop()
      spawnerRobots.limpiarRobots()
      game.addVisual(self)
      musicaDeFondo.stop()
      sonidoDeGameOver.play()
      game.addVisual(cartelReiniciar)
      game.addVisual(cartelGameOver)
      keyboard.r().onPressDo({ self.reiniciar() }) 
    }
  }

  method reiniciar() { 
    finalizado = false
    game.clear()
    sonidoDeGameOver.stop()
    self.menuInicio()
  }

  method iniciarPartida(){

    game.clear()
    fondo.image("Fondo.jpg")
    game.addVisual(fondo)
    game.addVisual(personajePrincipal)
    musicaFondoInicio.stop()
    barraVida.personaje(personajePrincipal)
    game.addVisual(barraVida)
    etiquetaDeBalas.personaje(personajePrincipal)
    game.addVisual(etiquetaDeBalas)
    etiquetaVida.personaje(personajePrincipal)
    game.addVisual(etiquetaVida)
    etiquetaMunicion.personaje(personajePrincipal)
    game.addVisual(etiquetaMunicion)
    activadoresCasa.forEach { activadorCasa => game.addVisual(activadorCasa) }
    personajePrincipal.reiniciarVida()
    personajePrincipal.reiniciarBalas()
    musicaDeFondo.volume(0.5)
    musicaDeFondo.play()

    game.onCollideDo(personajePrincipal, { elemento =>
      elemento.chocarConPersonaje(personajePrincipal)  // en vez de self.personajePrincipalRecibeDañoDe(enemigo) 
    })

    activadoresCasa.forEach { activadorCasa => self.perderAlRobotColisionarCon(activadorCasa) }

    //Teclas
    keyboard.up().onPressDo({personajePrincipal.subir()})
    keyboard.down().onPressDo({personajePrincipal.bajar()})
    keyboard.d().onPressDo({personajePrincipal.disparar()})

    //Eventos en relacion al tiempo
    aparecenRobots.start()
    apareceMunicion.start()//nuevo
    ganarJuego.start()
    apareceMunicion.start()
  }

  method perderAlRobotColisionarCon(activador) {
    game.onCollideDo(activador, { robot =>
      self.terminar()
      robot.mori()
    })
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

object cartelGameOver{
 method position() = game.at(3,2)
 method image()="game_over_re4_transparente.png"
}

object fondo { 
var property image = "menu_personajes_base.png" 
method position() = game.at(0,0)  
}
