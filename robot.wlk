import generadorAleatorio.*
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

    method chocarConPersonaje(personaje) {
        personaje.teHirieron()
        self.mori()
    }

    method aumentaDefensa(){
        vida += 50
    }

    method detenerse(){
        moverRobot.stop()
    }
}
class Robot inherits Enemigo(vida = 50) { 
    override method image() = "robotBasico.png" 
} 
class RobotFuerte inherits Enemigo(vida = 100){
    override method image() = "robotFuerteCamina.png"
} 
class RobotJefe inherits Enemigo(vida = 1000) {
    override method chocarConPersonaje(personaje){
        self.teHirieron()
    }
}
class RobotEscudero inherits RobotJefe{
    override method image() = "robotEscuderoCamina.png"
    method aumentaDefensaDeRobots(){
        self.detenerse() //Se detiene y se vuelve inmune al daño
        spawnerRobots.robotsActivos.forEach({robot => robot.aumentaDefensa() })
        //Aca deberia volver a moverse o fuera de este metodo?
    }
}
object spawnerRobots { 
    const robotsActivos = []
    method generarRobot() { 
        const columnaEntrada = 9 
        const posicionInicial = game.at(columnaEntrada, generadorAleatorio.filaAleatoria()) 
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
