import robot.*
import proyectiles.*
import generadorAleatorio.*
object spawnerRobots { 
    const robotsActivos = []
    const portalesActivos = []

    method robotsActivos(){
        return robotsActivos
    }

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

    method agregarRobot(robot) {
        robotsActivos.add(robot) 
        game.addVisual(robot)
        robot.avanzar()
    }

    method generarJefe(jefe){
        robotsActivos.add(jefe) 
        game.addVisual(jefe) 
        jefe.avanzar()
    }
    method eliminarRobot(robot) { 
        robotsActivos.remove(robot)
    }
    method limpiarRobots(){
        robotsActivos.clear()
    }
    method moverRobots() { //llamado al despausar el juego
        robotsActivos.forEach({ robot => robot.avanzar() })
    }
    method eliminarPortal(portal) { 
        portalesActivos.remove(portal)
    }
    method animarPortales() { //llamado al despausar el juego
        portalesActivos.forEach({ portal => portal.empezaAnimacion() })
    }
}

object spawnerProyectiles {
    const property proyectilesActivos = []
    method generarProyectil(proyectil) {
        proyectilesActivos.add(proyectil)
        game.addVisual(proyectil)
        proyectil.disparate()
    }
    method eliminarProyectil(proyectil) {
        proyectilesActivos.remove(proyectil)
    }
    method moverProyectiles() { //llamado al despausar el juego
        proyectilesActivos.forEach({ proyectil => proyectil.avanzar() })
    }
}

object spawnerMunicion {
    const municionDespawnea = game.tick(4000, { self.eliminarMunicion() }, false)
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