import interfaz.*
import generadorAleatorio.*
import direcciones.*
import personajes.*
import wollok.game.*
import etapaDelJuego.*
class Enemigo{ 
    var property position = game.at(9, 0) 
    var property vida = 100
    var property image = "robotBasico.png" 
    var inmovilizado = false
    var iconoTelaraña = null
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
        if (iconoTelaraña != null and game.hasVisual(iconoTelaraña)) { 
            game.removeVisual(iconoTelaraña) 
            iconoTelaraña = null 
        }
    }

    method mover() {
        position = position.left(1)
        self.verificarSiLlegoALaCasa()
    }

    method verificarSiLlegoALaCasa() {
        if (position.x() == 0) {
            etapaDelJuego.llegaALaCasa(self)
        }
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
    method inmovilizarPor(milisegundos) {
    inmovilizado = true
    moverRobot.stop()
    iconoTelaraña = new TelarañaArriba(robotAsignado = self)
    game.addVisual(iconoTelaraña)
    game.schedule(milisegundos, { 
        if (game.hasVisual(self)) { moverRobot.start() inmovilizado = false } 
        if (game.hasVisual(iconoTelaraña)) { game.removeVisual(iconoTelaraña) }
        })
    }
}
class Robot inherits Enemigo(vida = 50, image = "robotBasico.png" ) { 
} 
class RobotFuerte inherits Enemigo(vida = 100, image = "robotFuerteCamina.png"){
} 
class RobotJefe inherits Enemigo(vida = 400) {
    override method chocarConPersonaje(personaje){
        super(personaje)
        personaje.mori()
    }

    method activarHabilidad()
}
class RobotEscudero inherits RobotJefe(image = "robotEscudoCamina1.png"){
    var property esInmune = false
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
class RobotExplosivo inherits Enemigo(vida = 100, image = "robotExplosivoCamina3.png" ) {
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
class RobotVeloz inherits Enemigo(vida = 60 ) {
    var property etapa = camina
    const tickAlCorrer = game.tick(400, { self.mover() }, false)

    override method mover() {
        etapa.movimiento(self)
    }
    override method image() = etapa.imagen()

    method iniciarPreparacion() {
        position = position.left(1)
        imagenActual = "robotVelozPreparaAtaque.png"
        etapa = "pausa"

        // Pausa de 1 segundo en X = 5 antes de salir corriendo
        game.schedule(1000, {
            imagenActual = "robotVelozAtaque.png"
            etapa = "corriendo"
            moverRobot.stop()
            tickAlCorrer.start()
        })
    }

    method darUnPaso(){
        if (position.x() > 0) {
            position = position.left(1)
        }
    }

    method ejecutarSalto() {
        position = game.at(1, position.y())
        etapa = camina
        game.sound("robotSprint.mp3").play()
        tickAlCorrer.stop() 
        moverRobot.start()
    }
    
    override method mori() { 
        tickAlCorrer.stop() 
        super() 
    } 
    
    override method detenerse() { 
        tickAlCorrer.stop() 
        super() 
        }
}

object camina{
    
    method imagen() = "robotVelozCamina.png"

    method movimiento(robotVeloz){
        if (robotVeloz.position().x() == 6) {
            robotVeloz.iniciarPreparacion()
        } else {
            robotVeloz.darUnPaso()
        }
    
    }
}

object corre{

    method imagen() = "robotVelozGolpea.png"

    method movimiento(robotVeloz){
        if (robotVeloz.position().x() <= 3) {
            robotVeloz.ejecutarSalto()
        } else {
            robotVeloz.darUnPaso()
        }
    }
}

object pausa{

    method imagen() = "robotVelozSePrepara.png"

    method movimiento(robotVeloz){
        //no se mueve en esta etapa
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
        new RobotExplosivo(position = posicionInicial), new RobotVeloz(position = posicionInicial)]
        const nuevoRobot = robotsQuePuedenGenerarse.anyOne()
        const nuevoPortal = new Portal(position = posicionInicial)
        const sonidoDePortal = game.sound("portalSonido.wav")
        sonidoDePortal.volume(0.5)
        sonidoDePortal.play()
        game.addVisual(nuevoPortal)
        nuevoPortal.empezaAnimacion()
        game.schedule(600, { self.agregarRobot(nuevoRobot) })
    }

    method agregarRobot(robot) {
        robotsActivos.add(robot) 
        game.addVisual(robot)
        robot.avanzar()
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

class Portal {
    var property position
    var frameActual = 1
    const animacion = game.tick(100, { self.avanzaFrame() }, false)
    method image() = "portalRobots_" + frameActual + ".png"
    method teHirieron() {}
    method empezaAnimacion() {
        animacion.start()
    }
    method avanzaFrame() {
        if (frameActual == 12) {
            animacion.stop()
            game.removeVisual(self)
        }
        frameActual += 1
    }
}
