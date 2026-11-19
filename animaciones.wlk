import spawners.*
import etapaDelJuego.*
class Animacion {  
  var property frameActual = 0
  method image() = self.nombre() + frameActual + ".png"
  method position()
  const animacion = game.tick(self.duracionFrames(), { self.avanzaFrame() }, false)
  method avanzaFrame() {
      self.verificarSiTerminoAnimacion()
      frameActual += 1
  }
  method verificarSiTerminoAnimacion() {
    if (frameActual == self.ultimoFrame()) {
        animacion.stop()
        game.removeVisual(self)
        self.cambioAlTerminar()
    }
  }
  method empezaAnimacion() {
    animacion.start()
  }
  method nombre()
  method duracionFrames()
  method ultimoFrame()
  method cambioAlTerminar()
}
object iluminacion inherits Animacion {  
  override method position() = game.origin()
  method ilumina() {
    game.addVisual(self)
    self.frameActual(0)
    self.empezaAnimacion()
  }
  override method empezaAnimacion() {
    super()
    etapaDelJuego.desactivarCambioDePersonaje()
  }
  override method nombre() = "Iluminacion_"
  override method duracionFrames() = 400
  override method ultimoFrame() = 3
  override method cambioAlTerminar() {
    etapaDelJuego.activarCambioDePersonaje()
  }
}
class Portal inherits Animacion {
    const property robotASpawnear 
    const property position = robotASpawnear.position()
    method teHirieron() {}
    override method avanzaFrame() {
        if (frameActual == 6) {
            spawnerRobots.agregar(robotASpawnear)
        }
        super()
    }
    method inmovilizar() {}
    override method nombre() = "portalRobots_"
    override method duracionFrames() = 100
    override method ultimoFrame() = 12
    override method cambioAlTerminar() {
      spawnerRobots.eliminarPortal(self)
    }
}