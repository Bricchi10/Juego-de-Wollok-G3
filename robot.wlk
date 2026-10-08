import direcciones.*
import terminator.*
import wollok.game.*
import etapaDelJuego.*
class Enemigo{ 
    var property position = game.at(9, 0) 
    var vida = 100
    method image() = "robotBasico.png" 
    const moverRobot = game.tick(1500, { 
        position = izquierda.siguiente(position) 
        self.verificarJuegoPerdido() }, 
        false)

    method esEnemigo() = true

    method avanzar() {
        moverRobot.start()
    }

    method verificarJuegoPerdido() {
        if (position.x() == 1) {
            etapaDelJuego.terminar()
            moverRobot.stop()
        }
    }

    method teHirieron(){
        vida=vida-50
        if(vida<=0){
          moverRobot.stop()
          spawnerRobots.eliminarRobot(self)
        }
    }
}
class Robot inherits Enemigo(vida = 50) { 
    override method image() = "robotBasico.png" 
} 
object spawnerRobots { 
    const robotsActivos = [] 
    method generarRobot(robot) { 
        const nuevoRobot = robot 
        robotsActivos.add(nuevoRobot) 
        game.addVisual(nuevoRobot) 
        nuevoRobot.avanzar()
    }
   
    method eliminarRobot(robot) { 
        if(robotsActivos.contains(robot)){
        robotsActivos.remove(robot) 
        game.removeVisual(robot) 
        game.sound("muerteRobot.mp3").play()
        }
    }
    method limpiarRobots(){
        robotsActivos.clear()
    } 
}
