import wollok.game.*
import robot.*
import personajes.*
import proyectiles.*
import interfaz.*
import generadorAleatorio.*

object etapaDelJuego { 
  var property protagonista = new Personaje(personajeActual = terminator)
  const musicaFondoInicio = game.sound("cs-1-6-music-lobbys.mp3")
  const musicaDeFondo = game.sound("musicaNivel.mp3")
  const sonidoDeGameOver = game.sound("game-over.mp3")
  const sonidoDeVictoria = game.sound("victoria.mp3")
  const aparecenRobots = game.tick(4000, { self.generarRobots() }, false)
  const apareceMunicion = game.tick(10000, { self.generarMunicionDePersonaje() }, false)
  const ganarJuego = game.tick(70000,  { self.ganarPartida() }, false)
  const aumentoProgreso = game.tick(10000,  { self.incrementarProgreso() }, false)
  var property progresoActual = 0
  method menuInicio(){
      self.agregarFondo()
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
    protagonista.cambiarPersonajeA(terminator)
    fondo.image("menu_personajes_1_terminator.png")
  }

  method selSpiderman(){
    protagonista.cambiarPersonajeA(spiderman)
    fondo.image("menu_personajes_2_spiderman.png")
  }

  method selGoku(){
    protagonista.cambiarPersonajeA(goku)
    fondo.image("menu_personajes_3_goku.png")
  }


  method menuIstrucciones(){
    fondo.image("fondo_Instrucciones.png")
    keyboard.b().onPressDo({fondo.image("menu_personajes_1_terminator.png")})
  }

  method ganarPartida() {
    self.terminar()
    protagonista.mostrarVictoria()
    sonidoDeVictoria.play()
    game.addVisual(cartelVictoria)
    keyboard.r().onPressDo({ self.reiniciarVictoria() })
  }

  method perderPartida() { 
    self.terminar()
    protagonista.mostrarDerrota()
    sonidoDeGameOver.play()
    game.addVisual(cartelGameOver)
    keyboard.r().onPressDo({ self.reiniciarDerrota() }) 
  }

  method generarRobots() {
    spawnerRobots.generarRobot()
  }

  method generarMunicionDePersonaje() {
    spawnerMunicion.generarMunicion()
  }

  method incrementarProgreso() {
    progresoActual += 1
    if(progresoActual % 3 == 0) { //Si el progreso llega a la mitad o al final (es multiplo de 3) genera un jefe
      spawnerRobots.generarJefe(new RobotEscudero(position = game.at(9, generadorAleatorio.filaAleatoria())))
    }
    if(progresoActual == 6) { //Cuando se llega a la ultima etapa de progreso este para de aumentar y los robots dejan de aparecer
      self.detenerProgreso()
    }
  }

  method terminar() { 
    self.prepararPrimeraPantalla()
    spawnerRobots.limpiarRobots()
    game.addVisual(cartelReiniciar)
    progresoActual = 0
    self.detenerProgreso()
    apareceMunicion.stop()
    ganarJuego.stop()
    musicaDeFondo.stop()
  }

  method detenerProgreso() {
    aumentoProgreso.stop()
    aparecenRobots.stop()
  }

  method prepararPrimeraPantalla() {
    self.agregarFondo()
    game.addVisual(protagonista)
    fondo.image("FondoFuturo.jpg")
  }

  method agregarFondo() {
    game.clear()
    game.addVisual(fondo)
  }

  method reiniciar() {
    protagonista.levantate()
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
    game.addVisual(barraProgreso)
    self.prepararPersonaje()
    self.prepararMusica()
    self.prepararColisiones()
    self.prepararControles()
    self.prepararEventosDeTiempo()
  }

  method prepararPersonaje() {
    protagonista.position(game.at(1,1))
    barraVida.personaje(protagonista)
    game.addVisual(barraVida)
    etiquetaDeBalas.personaje(protagonista)
    game.addVisual(etiquetaDeBalas)
    etiquetaVida.personaje(protagonista)
    game.addVisual(etiquetaVida)
    protagonista.reiniciarVida()
    protagonista.reiniciarBalas()
  }

  method prepararMusica() {
    musicaFondoInicio.stop()
    musicaDeFondo.volume(0.5)
    musicaDeFondo.play()
  }

  method prepararColisiones() {
    game.onCollideDo(protagonista, { elemento =>
      elemento.chocarConPersonaje(protagonista)  // en vez de self.protagonistaRecibeDañoDe(enemigo) 
    })

    protagonista.proyectilesDisponibles().forEach({ proyectil =>
      self.enemigoEsHeridoAlChocarCon(proyectil)
    })
  }

  method enemigoEsHeridoAlChocarCon(proyectil) {
    game.onCollideDo(proyectil, { enemigo => proyectil.herirA(enemigo) })
  }

  method prepararControles() {
    keyboard.up().onPressDo({ protagonista.subir() })
    keyboard.down().onPressDo({ protagonista.bajar() })
    keyboard.d().onPressDo({ protagonista.disparar() })
    keyboard.a().onPressDo({ self.ganarPartida() }) //Tecla debug para probar cosas
    keyboard.c().onPressDo({ protagonista.cambiarPersonajeA(spiderman) }) //Tecla debug para probar cosas
    keyboard.v().onPressDo({ protagonista.cambiarPersonajeA(goku) }) //Tecla debug para probar cosas
  }

  method prepararEventosDeTiempo() {
    aparecenRobots.start()
    apareceMunicion.start()
    ganarJuego.start()
    aumentoProgreso.start()
  }

  method llegaALaCasa(enemigo) {
    enemigo.mori()
    self.perderPartida()
  }
}

object fondo { 
  var property image = "menu_personajes_base.png"
  method position() = game.at(0,0)
}
