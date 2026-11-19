import spawners.*
import interfaz.*
import robot.*
import wollok.game.*
import direcciones.*
import etapaDelJuego.*
import generadorAleatorio.*

//Superclase Proyectil
class Proyectil {
    var property position = game.at(game.width(), game.height() -1)
    const movimiento = game.tick(100, { self.mover() }, false)
    const property disparador
    var property tipoDeProyectil

    method image() = tipoDeProyectil.image()

    method avanza() {
        movimiento.start()
    }

    method mover() {
        position = position.right(1)
        self.verificarSiEstaFueraDelTablero()
    }

    method mori() {
        movimiento.stop()
        game.removeVisual(self)
        disparador.agregarProyectilDisponible(self)
        spawnerProyectiles.eliminar(self)
    }

    method enemigosDetras() = game.getObjectsIn(position.left(2))

    method herirA(elemento) {
        elemento.teHirieron()
        tipoDeProyectil.efectoAlImpactar(self, elemento)
    }

    method verificarSiEstaFueraDelTablero() {
        if (not tablero.dentro(self.position())) {
            self.mori() // Si sale de la pantalla, se destruye
        }
    }

    method teHirieron() { }
}
//(Proyectil Terminator)
class Bala {
    method image() = "proyectilDisparo.png"
    method efectoAlImpactar(proyectil, elemento) {
        proyectil.mori()
    }
}
//(Proyectil Spiderman)
class Telaraña inherits Bala {
    override method image() = "proyectilTelaraña.png"

    override method efectoAlImpactar(proyectil, elemento) {
        if (game.hasVisual(elemento)) {
            elemento.inmovilizar()
        }
        super(proyectil, elemento)
    }
}
//(Proyectil Goku)
class Energia inherits Bala {
    override method image() = "bolaEnergiaAzul.png"
    override method efectoAlImpactar(proyectil,elemento) {
        if (game.hasVisual(elemento)) { //el proyectil solo se destruye si el robot aguantó el daño, si no lo atraviesa
            super(proyectil, elemento)
        }
    }
}
//Municiones
class Carga {
    var property position
    method image() = etapaDelJuego.protagonista().imagenCarga()
    
    method chocarConPersonaje(personaje) {
        personaje.recargar()
        game.removeVisual(self)
        game.sound(personaje.sonidoCarga()).play()
    }
}