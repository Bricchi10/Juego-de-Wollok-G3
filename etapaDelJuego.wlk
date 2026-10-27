import wollok.game.*
import robot.*
import personajes.*
import proyectiles.*
import activador.*
import interfaz.*
import generadorAleatorio.*

object etapaDelJuego { 
  var property personajePrincipal = new Terminator()
  const musicaFondoInicio = game.sound("cs-1-6-music-lobbys.mp3")
  const musicaDeFondo = game.sound("musicaNivel.mp3")
  const sonidoDeGameOver = game.sound("game-over.mp3")
  const sonidoDeVictoria = game.sound("victoria.mp3")
  const aparecenRobots = game.tick(4000, { self.generarRobots() }, false)
  const apareceMunicion = game.tick(12000, { self.generarMunicionDePersonaje() }, false)
  const ganarJuego = game.tick(180000,  { self.ganarPartida() }, false)
  const aumentoProgreso = game.tick(30000,  { self.incrementarProgreso() }, false)
  var property progresoActual = 0
  method menuInicio(){
      game.clear()
      game.addVisual(fondo)
      self.selTerminator()
      musicaFondoInicio.shouldLoop(true)
      musicaFondoInicio.volume(0.8)
      musicaFondoInicio.play()
      keyboard.space().onPressDo({self.iniciarPartida()})
      keyboard.i().onPressDo({self.menuIstrucciones()})
      keyboard.num1().onPressDo({self.selTerminator()})
      keyboard.num2().onPressDo({self.selSpiderman()})
      keyboard.num3().onPressDo({self.selGoku()})
  }

  method selTerminator()  {
    personajePrincipal = new Terminator()
    fondo.image("menu_personajes_1_terminator.png")
  }

  method selSpiderman(){
    personajePrincipal = new Spiderman()
    fondo.image("menu_personajes_2_spiderman.png")
  }

  method selGoku(){
    personajePrincipal = new Goku()
    fondo.image("menu_personajes_3_goku.png")
  }


  method menuIstrucciones(){
    fondo.image("")
    keyboard.b().onPressDo({self.menuInicio()})
  }

  method ganarPartida() {
    self.terminar()
    game.addVisual(cartelVictoria)
    sonidoDeVictoria.play()
    keyboard.r().onPressDo({ self.reiniciarVictoria() })
  }

  method generarRobots() {
    spawnerRobots.generarRobot()
  }

  method generarMunicionDePersonaje() {
    spawnerMunicion.generarMunicion()
  }

  method incrementarProgreso() {
    progresoActual += 1
    if(progresoActual == 3){ //Por ahora solo aparece uno, por que si no, no es posible ganar con la cantidad de balas actuales
      spawnerRobots.generarJefe(new RobotEscudero(position = game.at(9, generadorAleatorio.filaAleatoria())) )
    }
    if(progresoActual == 6){ //Cuando se llega a la ultima etapa de progreso del nivel para de aumentar
      aumentoProgreso.stop()
    }
  }

  method terminar() { 
    self.prepararPrimeraPantalla()
    spawnerRobots.limpiarRobots()
    game.addVisual(cartelReiniciar)
    progresoActual = 0
    aparecenRobots.stop()
    apareceMunicion.stop()
    ganarJuego.stop()
    musicaDeFondo.stop()
    aumentoProgreso.stop()
  }

  method prepararPrimeraPantalla() {
    game.clear()
    game.addVisual(fondo)
    game.addVisual(personajePrincipal)
    fondo.image("FondoFuturo.jpg")
  }

  method terminarDerrota() { 
    self.terminar()
    personajePrincipal.mostrarDerrota()
    sonidoDeGameOver.play()
    game.addVisual(cartelGameOver)
    keyboard.r().onPressDo({ self.reiniciarDerrota() }) 
  }

  method reiniciar() {
    game.clear()
    self.menuInicio()
  }

  method reiniciarDerrota() { 
    sonidoDeGameOver.stop()
    self.reiniciar()
  }
  
  method reiniciarVictoria() { 
    sonidoDeVictoria.stop()
    self.reiniciar()
  }

  method iniciarPartida(){
    self.prepararPrimeraPantalla()
    personajePrincipal.position(game.at(1,1))
    musicaFondoInicio.stop()
    barraVida.personaje(personajePrincipal)
    game.addVisual(barraVida)
    etiquetaDeBalas.personaje(personajePrincipal)
    game.addVisual(etiquetaDeBalas)
    etiquetaVida.personaje(personajePrincipal)
    game.addVisual(etiquetaVida)
    game.addVisual(barraProgreso)

    (1 .. game.height() -2).forEach({ y =>
      const activador = new Activador(position = game.at(0,y))
      game.addVisual(activador)
      self.perderAlRobotColisionarCon(activador)
    })

    personajePrincipal.reiniciarVida()
    personajePrincipal.reiniciarBalas()
    musicaDeFondo.volume(0.5)
    musicaDeFondo.play()

    game.onCollideDo(personajePrincipal, { elemento =>
      elemento.chocarConPersonaje(personajePrincipal)  // en vez de self.personajePrincipalRecibeDañoDe(enemigo) 
    })

    //Teclas
    keyboard.up().onPressDo({personajePrincipal.subir()})
    keyboard.down().onPressDo({personajePrincipal.bajar()})
    keyboard.d().onPressDo({personajePrincipal.disparar()})
    //keyboard.a().onPressDo({spawnerRobots.generarJefe()})

    //Eventos en relacion al tiempo
    aparecenRobots.start()
    apareceMunicion.start()
    ganarJuego.start()
    aumentoProgreso.start()
  }

  method perderAlRobotColisionarCon(activador) {
    game.onCollideDo(activador, { robot =>
      self.llegaALaCasa(robot)
    })
  }

  method llegaALaCasa(enemigo) {
    enemigo.mori()
    self.terminarDerrota()
  }
}

object fondo { 
var property image = "menu_personajes_base.png" 
method position() = game.at(0,0)  
}
