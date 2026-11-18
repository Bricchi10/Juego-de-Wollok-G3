import spawners.*
import interfaz.*
import generadorAleatorio.*
import direcciones.*
import personajes.*
import wollok.game.*
import etapaDelJuego.*
//Superclase Enemigo
class Enemigo{ 
    var property position = game.at(9, 0) 
    var property vida = 100
    var property image = "robotBasico.png"
    var property inmovilizado = false
    const moverRobot = game.tick(self.velocidad(), { self.mover() }, false)
    const iconoDefensa = new DefensaArriba(robotAsignado = self)
    const iconoTelaraña = new TelarañaArriba(robotAsignado = self)
    const liberarRobot = game.tick(2000, { self.liberate() }, false)

    method avanza() {
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
        liberarRobot.stop()
        game.removeVisual(self)
        game.removeVisual(iconoDefensa)
        game.removeVisual(iconoTelaraña)
        spawnerRobots.eliminar(self)
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
        liberarRobot.stop()
        if (game.hasVisual(self)) {
            moverRobot.start()
            inmovilizado = false
            game.removeVisual(iconoTelaraña)
        }
    }
    method velocidad() = 1500 //cada cuantos ms da un paso
}
//Robots comunes
class Robot inherits Enemigo(vida = 50, image = "robotBasico.png" ) { 
} 
class RobotFuerte inherits Enemigo(vida = 100, image = "robotFuerteCamina.png"){
}
//Robots especiales 
class RobotExplosivo inherits Enemigo(vida = 100, image = "robotExplosivoCamina3.png" ) {
    override method chocarConPersonaje(personaje) {
        game.sound("explosion.mp3").play() 
        personaje.teHirieron()
        game.addVisual(explosion)
        explosion.position(self.position())
        explosion.esfumate()
        personaje.inmovilizar() // Inmoviliza al jugador durante 3000 ms
        self.mori()
    }

    method eliminarExplosion() {
        
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
        self.preparaAtaque()
    }

    method correr() {
        preparacionAtaque.stop()
        if (game.hasVisual(self)) {
            etapa = corre
            self.empiezaACorrer()
        }
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

    override method avanza() {
        super()
        etapa.despausar(self)
    }

    method empiezaACorrer() {
        moverRobot.stop()
        tickAlCorrer.start()
    }

    method preparaAtaque() {
        preparacionAtaque.start()
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

    method despausar(robotVeloz) { }
}

object corre{

    method imagen() = "robotVelozAtaque.png"

    method movimiento(robotVeloz){
        if (robotVeloz.position().x() == 3) {
            robotVeloz.ejecutarSalto()
        } else {
            robotVeloz.darUnPaso()
        }
    }

    method despausar(robotVeloz) {
        robotVeloz.empiezaACorrer()
    }
}

object pausa{

    method imagen() = "robotVelozPreparaAtaque.png"

    method movimiento(robotVeloz){
        //no se mueve en esta etapa
    }

    method despausar(robotVeloz) {
        robotVeloz.preparaAtaque()
    }
}
//Robots Jefes
class RobotEscudero inherits Enemigo(vida = 400, image = "robotEscudoCamina.png") {
    const detenerCobertura = game.tick(6000, { self.dejaDeCubrirse() }, false)
    var esInmune = false

    override method mover() { 
        super()
        self.verificarSiLlegoALaCelda5()
    }

    method verificarSiLlegoALaCelda5() {
        if (position.x() == 6) {
            self.aumentaDefensaDeRobots()
        }
    }
    
    method aumentaDefensaDeRobots(){
        game.sound("armaduraInvocada.wav").play()
        self.cubrirse()
        spawnerRobots.robotsActivos().forEach({robot => 
            robot.aumentaDefensa()
        })
        etapaDelJuego.generarMunicionDePersonaje() //Ayuda al jugador dandole municiones
    }

    override method chocarConPersonaje(personaje){
        super(personaje)
        personaje.mori()
    }

    override method aumentaDefensa(){}

    override method teHirieron(){
        if (esInmune) {
            game.sound("shieldhit.ogg").play()
        } else {
            super()
        }
    }

    method cubrirse(){
        self.detenerse()
        image = "robotEscudoDefensa.png"
        esInmune = true //Se detiene y se vuelve inmune al daño   
        detenerCobertura.start() //Vuelve a moverse despues de 4 segundos
    }

    method dejaDeCubrirse(){
        detenerCobertura.stop()
        esInmune = false
        image = "robotEscudoCamina.png"
        self.avanza()        
    }

    override method avanza(){
        super()
        if (esInmune) {
            detenerCobertura.start()
        }
    }

    override method velocidad() = 3000
}
class RobotInvocador inherits Enemigo(vida = 300, image = "robotInvocadorPasivo.png") {
    override method position() = game.at(9, 3)
    const invocacion = game.tick(7000, { self.invocaEsbirros() }, false)
    const volverAPasivo = game.tick(1500, { self.volverAEstarPasivo() }, false)

    override method avanza() {
        invocacion.start()
        self.volverAEstarPasivo()
    }
    
    method spritePasivo() = "robotInvocadorPasivo.png"

    method spriteActivo() = "robotInvocadorActivo.png"

    override method mori() {
      invocacion.stop()
      game.sound("muerteInvocador.mp3").play()
      super()
    }

    method invocaEsbirros() {
        image = self.spriteActivo()

        self.invocarEn(self.position().up(1))
        self.invocarEn(self.position().down(1))
        self.invocarEn(self.position().left(1))

        game.sound("Invocacion.mp3").play()

        volverAPasivo.start()
    }

    method volverAEstarPasivo() {
        image = self.spritePasivo()
        volverAPasivo.stop()
    }

    method invocarEn(posicionDestino) {
        const esbirro = new Robot(position = posicionDestino)
        spawnerRobots.agregar(esbirro)
    }
}
//Portal de robots
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
            spawnerRobots.agregar(robotASpawnear)
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
