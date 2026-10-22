import generadorAleatorio.*
import direcciones.*
import personajes.*
import wollok.game.*
import etapaDelJuego.*
class Enemigo{ 
    var property position = game.at(9, 0) 
    var property vida = 100
    var property estaDetenido = false
    method image() = "robotBasico.png" 
    const moverRobot = game.tick(1500, { 
        self.mover() 
        estaDetenido = false
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
        estaDetenido = true
    }
}
class Robot inherits Enemigo(vida = 50) { 
    override method image() = "robotBasico.png" 
} 
class RobotFuerte inherits Enemigo(vida = 100){
    override method image() = "robotFuerteCamina.png"
} 
class RobotJefe inherits Enemigo(vida = 500) {
    override method chocarConPersonaje(personaje){
        super(personaje)
        personaje.teHirieron()
        personaje.teHirieron()
        personaje.teHirieron()
    }

    method activarHabilidad()
}
class RobotEscudero inherits RobotJefe{
    override method image() = "robotEscudoCamina1.png"
    method aumentaDefensaDeRobots(){
        self.detenerse() //Se detiene y se vuelve inmune al daño
        spawnerRobots.robotsActivos().forEach({robot => robot.aumentaDefensa() })
        game.schedule(4000, { self.avanzar() }  ) //Vuelve a moverse despues de 4 segundos
    }

    override method teHirieron(){
        if(vida <= 0){
            self.mori()
        } else if(not estaDetenido){
            vida= vida-50
        }
    }

    override method activarHabilidad(){
        self.aumentaDefensaDeRobots()
    }
}
object spawnerRobots { 
    const robotsActivos = []

    method robotsActivos(){
        return robotsActivos
    }
    method agregarRobot(robot){ //Preguntar a profe como evitar esto, ya que solo se utiliza en el test
        robotsActivos.add(robot)
    }
    method generarRobot() { 
        const columnaEntrada = 9 
        const posicionInicial = game.at(columnaEntrada, generadorAleatorio.filaAleatoria()) 
        const robotsQuePuedenGenerarse = [new Robot(position = posicionInicial), new RobotFuerte(position = posicionInicial)]
        const nuevoRobot = robotsQuePuedenGenerarse.anyOne()
        robotsActivos.add(nuevoRobot) 
        game.addVisual(nuevoRobot) 
        nuevoRobot.avanzar()
    }

    method generarJefe(jefe){
        robotsActivos.add(jefe) 
        game.addVisual(jefe) 
        jefe.avanzar()
        game.schedule(6000,{jefe.activarHabilidad()} ) //En lugar de aumentar defensa activar habilidad
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
