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
class RobotJefe inherits Enemigo(vida = 400) {
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
        game.schedule(4000, { self.dejaDeCubrirse() }  ) //Vuelve a moverse despues de 4 segundos
        etapaDelJuego.generarMunicionDePersonaje() //Ayuda al jugador dandole municiones
    }

    override method aumentaDefensa() {}

    override method teHirieron(){
        if (esInmune) {
            game.sound("shieldhit.ogg").play()
        } else {
            super()
        }
    }

    override method activarHabilidad(){
        self.aumentaDefensaDeRobots()
    }

    method dejaDeCubrirse() {
        self.avanzar()
        self.esInmune(false)
    }
}
class RobotExplosivo inherits Enemigo(vida = 100) {
    override method image() = "robotExplosivoCamina3.png" 
    override method chocarConPersonaje(personaje) {
        game.sound("explosion.mp3").play() 
        personaje.teHirieron()
        const efectoExplosion = new Explosion(position = personaje.position().right(1)) 
        game.addVisual(efectoExplosion)
        game.schedule(1000, { game.removeVisual(efectoExplosion) })
        personaje.inmovilizarPor(3000) // Inmoviliza al jugador durante 3000 ms
        self.mori()
    }
}
class RobotVeloz inherits Enemigo(vida = 60) {
    var etapa = "caminando"
    var imagenActual = "robotVelozCamina.png"

    override method image() = imagenActual

    override method mover() {
        if (etapa == "caminando") {
            self.moverCaminando()
        } else if (etapa == "corriendo") {
            self.moverCorriendo()
        } else if (etapa == "reposo") {
            self.darUnPaso()
        }
        // Si etapa == "pausa", no entra a ningún if y se queda congelado durante el segundo de preparación
    }

    method moverCaminando() {
        if (position.x() == 6) {
            self.iniciarPreparacion()
        } else {
            self.darUnPaso()
        }
    }

    method moverCorriendo() {
        if (position.x() <= 3) {
            self.ejecutarSalto()
        } else {
            self.darUnPaso()
        }
    }

    method iniciarPreparacion() {
        position = izquierda.siguiente(position) 
        imagenActual = "robotVelozSePrepara.png"
        etapa = "pausa"

        // Pausa de 1 segundo en X = 5 antes de salir corriendo
        game.schedule(1000, {
            imagenActual = "robotVelozGolpea.png"
            etapa = "corriendo"
        })
    }

    method darUnPaso(){
        if (position.x() > 2) {
            position = izquierda.siguiente(position)
        }
    }

    method ejecutarSalto() {
        const personaje = etapaDelJuego.personajePrincipal()
        position = game.at(1, position.y())
        imagenActual = "robotVelozCamina.png"
        etapa = "reposo"
        game.sound("robotSprint.mp3").play()

        if (position == personaje.position()) {
            self.chocarConPersonaje(personaje)
        }
    }
}
object spawnerRobots { 
    const robotsActivos = []

    method robotsActivos(){
        return robotsActivos
    }
    method generarRobot() { 
        const posicionInicial = game.at(9, generadorAleatorio.filaAleatoria()) 
        const robotsQuePuedenGenerarse = [new Robot(position = posicionInicial), new RobotFuerte(position = posicionInicial),
        new RobotExplosivo(position = posicionInicial),new RobotVeloz(position = posicionInicial)]
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
