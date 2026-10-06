import direcciones.*
import terminator.*
import wollok.game.*
import etapaDelJuego.*
class Enemigo{ 
    var property position = game.at(9, 0) 
    var vida=100
    method image() = "robotBasico.png" 

    method esEnemigo() = true

    method avanzar() {
        if (game.hasVisual(self) && game.colliders(self).isEmpty()) {
            position = izquierda.siguiente(position)
        }
        self.verificarJuegoPerdido()
    }

    method verificarJuegoPerdido() {
        if (position.x() == 1 && game.hasVisual(self) && game.colliders(self).isEmpty()) {
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
        game.onTick(1500, "moverRobot", { => nuevoRobot.avanzar() })
    }
    method eliminarRobot(robot) { 
        if(robotsActivos.contains(robot)){
        robotsActivos.remove(robot) 
        game.removeVisual(robot) 
        game.sound("muerteRobot.mp3").play()
        }
    } 
}
