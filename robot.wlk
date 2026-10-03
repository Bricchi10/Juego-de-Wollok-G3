import direcciones.*
import terminator.*
import wollok.game.* 
class Robot { 
    var property position = game.at(9, 0) 
    method image() = "robotBasico.png" 
    method avanzar() {
        if (game.hasVisual(self) && self.noHayObstaculos() && game.colliders(self).isEmpty()) {
            position = izquierda.siguiente(position)
        }
        self.verificarJuegoPerdido()
    }
    method noHayObstaculos() {
        return game.getObjectsIn(game.at(position.x() -1, position.y())).isEmpty()
    }
    method verificarJuegoPerdido() {
        if (position.x() == 1) {
            game.say(self, "Perdiste!")
            game.schedule(1000, { game.stop() })
        }
    }
} 
object spawnerRobots { 
    const robotsActivos = [] 
    method generarRobot() { 
        const filaAleatoria = (1 .. 5).anyOne() 
        const columnaEntrada = 9 
        const posicionInicial = game.at(columnaEntrada, filaAleatoria) 
        const nuevoRobot = new Robot(position = posicionInicial) robotsActivos.add(nuevoRobot) 
        game.addVisual(nuevoRobot)
        game.onTick(1500, "moverRobot", { => nuevoRobot.avanzar() })
    }
    method eliminarRobot(robot) { 
        robotsActivos.remove(robot) game.removeVisual(robot) 
    }
}
