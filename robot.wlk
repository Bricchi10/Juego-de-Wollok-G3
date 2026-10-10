import direcciones.*
import personajes.*
import wollok.game.*
import etapaDelJuego.*
class Enemigo{ 
    var property position = game.at(9, 0) 
    var vida=100
    method image() = "robotBasico.png" 
    const moverRobot = game.tick(1500, { 
        position = izquierda.siguiente(position) 
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
}
class Robot inherits Enemigo(vida = 50) { 
    override method image() = "robotBasico.png" 
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
        nuevoRobot.avanzar()
    }
    /*
    method moverRobots() { 
        robotsActivos.forEach({ robot => robot.avanzar() }) 
    } */
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
