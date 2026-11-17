import robot.*
import proyectiles.*
import generadorAleatorio.*
class Spawner {
    const property elementosActivos = []
    method agregar(elemento) {
        elementosActivos.add(elemento)
        game.addVisual(elemento)
        elemento.avanza()
    }
    method eliminar(elemento) {
        elementosActivos.remove(elemento)
    }
    method moverElementos() { //llamado al despausar el juego
        elementosActivos.forEach({ elemento => elemento.avanza() })
    }
    method limpiarElementos(){
        elementosActivos.clear()
    }
}

object spawnerRobots inherits Spawner { 
    const portalesActivos = []

    method robotsActivos() = elementosActivos

    method generarRobot() {
        const nuevoPortal = new Portal(robotASpawnear = self.robotAleatorio())
        const sonidoDePortal = game.sound("portalSonido.wav")
        sonidoDePortal.volume(0.5)
        sonidoDePortal.play()
        game.addVisual(nuevoPortal)
        portalesActivos.add(nuevoPortal) 
        nuevoPortal.empezaAnimacion()
    }

    method robotAleatorio() {
        const posicionInicial = game.at(9, generadorAleatorio.filaAleatoria()) 
        const robotsQuePuedenGenerarse = [new Robot(position = posicionInicial), new RobotFuerte(position = posicionInicial), 
        new RobotExplosivo(position = posicionInicial), new RobotVeloz(position = posicionInicial)]
        return robotsQuePuedenGenerarse.anyOne()
    }
    method eliminarPortal(portal) { 
        portalesActivos.remove(portal)
    }
    method animarPortales() { //llamado al despausar el juego
        portalesActivos.forEach({ portal => portal.empezaAnimacion() })
    }
}

object spawnerProyectiles inherits Spawner {
    method proyectilesActivos() = elementosActivos
    
    override method limpiarElementos(){
        elementosActivos.forEach({ proyectil => proyectil.mori() })
        super()
    }
}

object spawnerMunicion {
    const municionDespawnea = game.tick(4500, { self.eliminarMunicion() }, false)
    var property municionActual = null

    method generarMunicion() {
        const posicionInicial = generadorAleatorio.filaAleatoriaVaciaEnX(1)
        const nuevaMunicion = new Carga(position = posicionInicial)
        game.addVisual(nuevaMunicion)
        municionActual = nuevaMunicion
        self.despawnearMunicion()
    }

    method despawnearMunicion() {
        municionDespawnea.start()
    }

    method eliminarMunicion() {
        game.removeVisual(municionActual)
        municionDespawnea.stop()
    }
}