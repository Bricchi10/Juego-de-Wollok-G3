import wollok.game.*
import robot.*
import terminator.*
import bala.*
import paredes.*
object etapaDelJuego { 
  var finalizado = false 
  
  method position() = game.at(3, 2)
  method image(){
    return "game_over_re4_transparente.png"
  }

  method terminar() { 
    if (not finalizado) { 
      finalizado = true 
      game.clear()
      game.removeTickEvent("aparecenRobots") 
      game.removeTickEvent("muevenRobots")
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
    const personajePrincipal= new Terminator()
    //Personaje

    game.addVisual(personajePrincipal)
    barraVida.personaje(personajePrincipal)//nuevo
    game.addVisual(barraVida)
    etiquetaVida.personaje(personajePrincipal)//nuevo
    game.addVisual(etiquetaVida)
    
    //Objetos invisibles
    game.addVisual(paredInvisibleDeArriba)
    game.addVisual(paredInvisibleDeAbajo)

    game.onCollideDo(paredInvisibleDeArriba, {personaje => personaje.bajar() } )
    game.onCollideDo(paredInvisibleDeAbajo, {personaje => personaje.subir() } )
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
    game.onTick(4000, "aparecenRobots", { spawnerRobots.generarRobot() })
    game.onTick(1500, "muevenRobots", { spawnerRobots.moverRobots() })

}
}
object cartelReiniciar { 
    method position() = game.at(5, 2) 
    method image() = "cartelDeReinicio.png"
}