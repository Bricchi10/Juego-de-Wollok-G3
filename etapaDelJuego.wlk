import wollok.game.*
import robot.*
import personajes.*
import proyectiles.*
import activador.*
import interfaz.*
import generadorAleatorio.*

object etapaDelJuego { 
  var finalizado = false 
  var property personajePrincipal = new Terminator() //Personaje
  const musicaFondoInicio = game.sound("cs-1-6-music-lobbys.mp3")
  const aparecenRobots = game.tick(4000, { self.generarRobots() }, false)
  const apareceMunicion = game.tick(12000, { self.generarMunicionDePersonaje() }, false)//nuevo
  const ganarJuego = game.tick(180000,  { self.ganarPartida() }, false)
  const musicaDeFondo = game.sound("musicaNivel.mp3")
  const sonidoDeGameOver = game.sound("game-over.mp3")
  const sonidoDeVictoria = game.sound("victoria.mp3")
  const aumentoBarraProgreso = game.tick(30000,  { self.incrementarProgreso() }, false)
  var property progresoActual = 0
  method menuInicio(){
      game.clear()
      self.selTerminator()
      game.addVisual(fondo)
      musicaFondoInicio.shouldLoop(true)
      musicaFondoInicio.volume(0.8)
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
    fondo.image("")
    keyboard.b().onPressDo({self.menuInicio()})
  }

  method ganarPartida() {
    game.schedule(1000, { self.terminarVictoria() })
  }

  method generarRobots() {
    spawnerRobots.generarRobot()
  }

  method generarMunicionDePersonaje() { //nuevo
    spawnerMunicion.generarMunicion()
  }

  method incrementarProgreso() {
    progresoActual = (progresoActual + 1).min(6)
    if(progresoActual == 3){ //Por ahora solo aparece uno, por que si no, no es posible ganar con la cantidad de balas actuales
      spawnerRobots.generarJefe(new RobotEscudero(position = game.at(9, generadorAleatorio.filaAleatoria())) )
    }
  }

  method position() = game.at(3, 2)

  method image(){
    return "game_over_re4_transparente.png"
  }

  method terminar() { 
    finalizado = true 
    game.clear()
    game.addVisual(fondo)
    game.addVisual(personajePrincipal)
    fondo.image("FondoFuturo.jpg")
    aparecenRobots.stop()
    apareceMunicion.stop()
    ganarJuego.stop()
    spawnerRobots.limpiarRobots()
    musicaDeFondo.stop()
    game.addVisual(cartelReiniciar)
    aumentoBarraProgreso.stop()
    progresoActual = 0
  }

  method terminarDerrota() { 
    self.terminar()
    personajePrincipal.mostrarDerrota()
    game.addVisual(cartelGameOver)
    sonidoDeGameOver.play()
    keyboard.r().onPressDo({ self.reiniciarDerrota() }) 
  }

  method reiniciar() {
    finalizado = false
    game.clear()
    self.menuInicio()
  }

  method reiniciarDerrota() { 
    sonidoDeGameOver.stop()
    self.reiniciar()
  }
  
  method terminarVictoria() {
    self.terminar()
    game.addVisual(cartelVictoria)
    sonidoDeVictoria.play()
    keyboard.r().onPressDo({ self.reiniciarVictoria() })
}
method reiniciarVictoria() { 
    sonidoDeVictoria.stop()
    self.reiniciar()
  }

  method iniciarPartida(){
    game.clear()
    fondo.image("FondoFuturo.jpg")
    game.addVisual(fondo)
    game.addVisual(personajePrincipal)
    personajePrincipal.position( game.at(1,1))
    musicaFondoInicio.stop()
    barraVida.personaje(personajePrincipal)
    game.addVisual(barraVida)
    etiquetaDeBalas.personaje(personajePrincipal)
    game.addVisual(etiquetaDeBalas)
    etiquetaVida.personaje(personajePrincipal)
    game.addVisual(etiquetaVida)
    game.addVisual(barraProgreso)
    aumentoBarraProgreso.start()

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
    keyboard.a().onPressDo({self.progresoActual(2)})

    //Eventos en relacion al tiempo
    aparecenRobots.start()
    apareceMunicion.start()//nuevo
    ganarJuego.start()
    apareceMunicion.start()
  }

  method perderAlRobotColisionarCon(activador) {
    game.onCollideDo(activador, { robot =>
      self.llegaALaCasa(robot)
    })
  }

  method llegaALaCasa(enemigo) {
    self.terminarDerrota()
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

object cartelVictoria{
 method position() = game.at(3,2)
 method image()="cartel_victoria.png"
}

object fondo { 
var property image = "menu_personajes_base.png" 
method position() = game.at(0,0)  
}
