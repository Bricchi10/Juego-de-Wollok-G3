import spawners.*
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
    const moverRobot = game.tick(self.velocidad(), { self.mover() }, false)
    const iconoDefensa = new DefensaArriba(robotAsignado = self)
    const iconoTelaraña = new TelarañaArriba(robotAsignado = self)
    const liberarRobot = game.tick(1000, { self.liberate() }, false)

    method avanzar() {
        if (!inmovilizado) {
            moverRobot.start()
        } else {
            liberarRobot.start()
        }
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
        game.removeVisual(iconoTelaraña)
        spawnerRobots.eliminarRobot(self)
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
    method inmovilizar() {
        if (!inmovilizado) {
            inmovilizado = true
            game.addVisual(iconoTelaraña)
            liberarRobot.start()
        }
        moverRobot.stop()
    }
    method liberate() {
        if (game.hasVisual(self)) {
            moverRobot.start()
            inmovilizado = false
            game.removeVisual(iconoTelaraña)
            liberarRobot.stop()
        }
    }
    method velocidad() = 1500 //cada cuantos ms da un paso
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
class RobotEscudero inherits RobotJefe(image = "robotEscudoCamina1.png") {
    const detenerCobertura = game.tick(4000, { self.dejaDeCubrirse() }, false)
    const aumentoDefensa = game.tick(6000, { self.aumentaDefensaDeRobots() }, false)
    var esInmune = false
    var habilidadActivada = false
    
    method aumentaDefensaDeRobots(){
        self.detenerse()
        esInmune = true //Se detiene y se vuelve inmune al daño
        spawnerRobots.robotsActivos().forEach({robot => 
            robot.aumentaDefensa()
        })
        game.sound("armaduraInvocada.wav").play()
        habilidadActivada = true
        detenerCobertura.start() //Vuelve a moverse despues de 4 segundos
        etapaDelJuego.generarMunicionDePersonaje() //Ayuda al jugador dandole municiones
        aumentoDefensa.stop()
    }

    override method aumentaDefensa(){}

    override method teHirieron(){
        if (esInmune) {
            game.sound("shieldhit.ogg").play()
        } else {
            super()
        }
    }

    override method activarHabilidad(){
      aumentoDefensa.start()
    }

    method dejaDeCubrirse(){
        detenerCobertura.stop()
        esInmune = false
        self.avanzar()
    }

    override method avanzar(){
        super()
        if (esInmune) {
            detenerCobertura.start()
        }
        if (!habilidadActivada) {
            self.activarHabilidad()
        }
    }

    override method velocidad() = 3000
}
class RobotInvocador inherits RobotJefe(vida = 300, image = "robotInvocadorPasivo.png") {
    override method position() = game.at(9, 3)

    override method avanzar() {
        game.schedule(6000, {self.activarHabilidad()})
    }
    
    method spritePasivo() = "robotInvocadorPasivo.png"

    method spriteActivo() = "robotInvocadorActivo.png"

    override method mori() {
      super()
      game.sound("muerteInvocador.mp3").play()
    }

    override method activarHabilidad() {
        image = self.spriteActivo()

        self.invocarEn(self.position().up(1))
        self.invocarEn(self.position().down(1))
        self.invocarEn(self.position().left(1))

        game.sound("Invocacion.mp3").play()

        game.schedule(1500, {
            if (vida > 0) {
                image = self.spritePasivo()
            }
        })

        game.schedule(7000, {
            if (vida > 0) {
                self.activarHabilidad()
            }
        })
    }

    method invocarEn(posicionDestino) {
        const esbirro = new Robot(position = posicionDestino)
        spawnerRobots.agregarRobot(esbirro)
    }
}
class RobotExplosivo inherits Enemigo(vida = 100, image = "robotExplosivoCamina3.png" ) {
    override method chocarConPersonaje(personaje) {
        game.sound("explosion.mp3").play() 
        personaje.teHirieron()
        const efectoExplosion = new Explosion(position = personaje.position().right(1)) 
        game.addVisual(efectoExplosion)
        game.schedule(1000, { game.removeVisual(efectoExplosion) })
        personaje.inmovilizar() // Inmoviliza al jugador durante 3000 ms
        self.mori()
    }
}
class RobotVeloz inherits Enemigo(vida = 60 ) {
    var property etapa = camina
    const tickAlCorrer = game.tick(400, { self.mover() }, false)
    const preparacionAtaque = game.tick(1000, { self.correr() }, false)

    override method mover() { 
        etapa.movimiento(self)
    }
    
    override method image() = etapa.imagen()

    override method mori(){ 
        super()
        tickAlCorrer.stop()
    } 
    
    override method detenerse() { 
        super()
        tickAlCorrer.stop()
    }
    

    method iniciarPreparacion() {
        position = position.left(1)
        etapa = pausa

        // Pausa de 1 segundo en X = 5 antes de salir corriendo
        preparacionAtaque.start()
    }

    method correr() {
        if (game.hasVisual(self)) {
            etapa = corre
            moverRobot.stop()
            tickAlCorrer.start()
        }
        preparacionAtaque.stop()
    }

    method darUnPaso(){
        if (position.x() > 0) {
            position = position.left(1)
            self.verificarSiLlegoALaCasa()
        }
    }

    method ejecutarSalto() {
        position = game.at(1, position.y())
        etapa = camina
        game.sound("robotSprint.mp3").play()
        tickAlCorrer.stop() 
        moverRobot.start()
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

    method imagen() = "robotVelozAtaque.png"

    method movimiento(robotVeloz){
        if (robotVeloz.position().x() <= 3) {
            robotVeloz.ejecutarSalto()
        } else {
            robotVeloz.darUnPaso()
        }
    }
}

object pausa{

    method imagen() = "robotVelozPreparaAtaque.png"

    method movimiento(robotVeloz){
        //no se mueve en esta etapa
    }
}

class Portal {
    method vida() = 999 //para que entienda el mensaje vida cuando una bala le pegue
    const property robotASpawnear 
    const property position = robotASpawnear.position()
    var frameActual = 1
    const animacion = game.tick(100, { self.avanzaFrame() }, false)
    method image() = "portalRobots_" + frameActual + ".png"
    method teHirieron() {}
    method empezaAnimacion() {
        animacion.start()
    }
    method avanzaFrame() {
        if (frameActual == 6) {
            spawnerRobots.agregarRobot(robotASpawnear)
        }
        if (frameActual == 12) {
            animacion.stop()
            game.removeVisual(self)
            spawnerRobots.eliminarPortal(self)
        }
        frameActual += 1
    }

    method inmovilizar() {}
}
