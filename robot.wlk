import direcciones.*
import personajes.*
import wollok.game.*
import etapaDelJuego.*
class Enemigo{ 
    var property position = game.at(9, 0) 
    var property vida = 100
    method image() = "robotBasico.png" 
    const moverRobot = game.tick(1500, { 
        self.mover()
        }, 
        false)

    method avanzar() {
        moverRobot.start()
    }

    method teHirieron(){
        vida=vida-50
        if(vida<=0){
          self.mori()
        }
    }

    method mori(){
        moverRobot.stop()
        spawnerRobots.eliminarRobot(self)
    }

    method mover() {
        position = izquierda.siguiente(position) 
    }
}
class Robot inherits Enemigo(vida = 50) { 
    override method image() = "robotBasico.png" 
} 
class RobotFuerte inherits Enemigo(vida = 100){
    override method image() = "robotFuerteCamina.png"
} 
object spawnerRobots { 
    const robotsActivos = []
    method generarRobot() { 
        const filaAleatoria = (1 .. 5).anyOne() 
        const columnaEntrada = 9 
        const posicionInicial = game.at(columnaEntrada, filaAleatoria) 
        const robotsQuePuedenGenerarse = [new Robot(position = posicionInicial), new RobotFuerte(position = posicionInicial)]
        const nuevoRobot = robotsQuePuedenGenerarse.anyOne()
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
