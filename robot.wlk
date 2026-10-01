import wollok.game.* 
class Robot { 
    var property position = game.at(9, 0) 
    method image() = "robot.png" 
    method avanzar() { 
        if (position.x() > 1) { 
            position = position.left(1) } 
        else { game.say(self, "Perdiste!") 
        } 
    } 

    method esEnemigo() = true
} 
object spawnerRobots { 
    const robotsActivos = [] 
    method generarRobot() { 
        const filaAleatoria = (1 .. 5).anyOne() 
        const columnaEntrada = 9 
        const posicionInicial = game.at(columnaEntrada, filaAleatoria) 
        const nuevoRobot = new Robot(position = posicionInicial) robotsActivos.add(nuevoRobot) 
        game.addVisual(nuevoRobot) 
    } 
    method moverRobots() { 
        robotsActivos.forEach({ robot => robot.avanzar() }) 
    } 
    method eliminarRobot(robot) { 
        robotsActivos.remove(robot) game.removeVisual(robot) 
    } 
}
