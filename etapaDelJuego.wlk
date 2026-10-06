import wollok.game.*
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
      game.addVisual(self)
      game.sound("game-over.mp3").play()
      game.addVisual(cartelReiniciar)
      keyboard.r().onPressDo({ self.reiniciar() }) 
    }
  }
  method reiniciar() { 
    finalizado = false
}
}
object cartelReiniciar { 
    method position() = game.at(5, 2) 
    method image() = "cartelDeReinicio.png"
}