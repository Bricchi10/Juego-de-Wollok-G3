import wollok.game.* 
import terminator.*
import etapaDelJuego.*
class Enemigo{ 
    var property position = game.at(9, 0) 
    var vida=100
    method image() = "robot.png" 

    method esEnemigo() = true



    method avanzar() { 
        if (position.x() > 1) { 
            position = position.left(1) } 
        else { game.say(self, "Perdiste!")
               etapaDelJuego.terminar() 
        } 
    } 


    method teHirieron(){
        vida=vida-50
        if(vida<=0){
          spawnerRobots.eliminarRobot(self)
        }
    }
}
class Robot inherits Enemigo(vida =50) { 
    override method image() = "robot.png" 
} 
object spawnerRobots { 
    const robotsActivos = [] 
    method generarRobot() { 
        const filaAleatoria = (1 .. 5).anyOne() 
        const columnaEntrada = 9 
        const posicionInicial = game.at(columnaEntrada, filaAleatoria) 
        const nuevoRobot = new Robot(position = posicionInicial) 
        robotsActivos.add(nuevoRobot) 
        game.addVisual(nuevoRobot) 
    } 
    method moverRobots() { 
        robotsActivos.forEach({ robot => robot.avanzar() }) 
    } 
    method eliminarRobot(robot) { 
        if(robotsActivos.contains(robot)){
        robotsActivos.remove(robot) 
        game.removeVisual(robot) 
        game.sound("muerteRobot.mp3").play()
        }
    } 
}
