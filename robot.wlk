import interfaz.*
import generadorAleatorio.*
import direcciones.*
import personajes.*
import wollok.game.*
import etapaDelJuego.*
class Enemigo{ 
    var property position = game.at(9, 0) 
    var property vida = 100
    method image() = "robotBasico.png" 
    const moverRobot = game.tick(1500, { self.mover() }, false)
    const iconoDefensa = new DefensaArriba(robotAsignado = self)

    method avanzar() {
        moverRobot.start()
    }

    method teHirieron(){
        game.sound("muerteRobot.mp3").play()
        self.bajarVidaOArmadura()
        if(vida <= 0){
          self.mori()
        }
    }

    method bajarVidaOArmadura() {
        if (game.hasVisual(iconoDefensa)) {
            game.removeVisual(iconoDefensa)
        } else {
            vida -= 50
        }
    }

    method mori(){
        moverRobot.stop()
        game.removeVisual(self)
        game.removeVisual(iconoDefensa)
        spawnerRobots.eliminarRobot(self)
    }

    method mover() {
        position = izquierda.siguiente(position) 
    }

    method chocarConPersonaje(personaje) {
        personaje.teHirieron()
        self.mori()
    }

    method aumentaDefensa() {
        game.addVisual(iconoDefensa)
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
class RobotJefe inherits Enemigo(vida = 350) {
    override method chocarConPersonaje(personaje){
        super(personaje)
        personaje.mori()
    }

    method activarHabilidad()
}
class RobotEscudero inherits RobotJefe{
    var property esInmune = false
    
    override method image() = "robotEscudoCamina1.png"
    method aumentaDefensaDeRobots(){
        self.detenerse()
        self.esInmune(true) //Se detiene y se vuelve inmune al daño
        spawnerRobots.robotsActivos().forEach({robot => 
            robot.aumentaDefensa()
        })
        game.sound("armaduraInvocada.wav").play()
        game.schedule(4000, { self.avanzar() self.esInmune(false) }  ) //Vuelve a moverse despues de 4 segundos
        etapaDelJuego.generarMunicionDePersonaje() //Ayuda al jugador dandole municiones
    }

    override method aumentaDefensa() {}

    override method teHirieron(){
        if (not esInmune) {
            super()
        } else {
            game.sound("shieldhit.ogg").play()
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
    method generarRobot() { 
        const posicionInicial = game.at(9, generadorAleatorio.filaAleatoria()) 
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
        robotsActivos.remove(robot)
    }
      method limpiarRobots(){
        robotsActivos.clear()
    }
}
