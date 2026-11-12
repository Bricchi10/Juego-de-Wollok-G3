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

    method disparate() {
        position = disparador.position().right(1)
        self.avanzar()
    }

    method avanzar() {
        movimiento.start()
    }

    method mover() {
        position = position.right(1)
        self.verificarSiEstaFueraDelTablero()
//daña a un enemigo que haya detras en caso que justo este se haya movido adelante y "esquive" el proyectil
    }

    method mori() {
        movimiento.stop()
        game.removeVisual(self)
        disparador.agregarProyectilDisponible(self)
        spawnerProyectiles.eliminarProyectil(self)
    }

    method enemigosDetras() = game.getObjectsIn(position.left(2))

    method herirA(elemento) {
        tipoDeProyectil.aplicarEfectoA(elemento)
        elemento.teHirieron()
        tipoDeProyectil.efectoAlImpactar(self,elemento) // Si impacta a un enemigo, se destruye
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
    method aplicarEfectoA(elemento) {}
    method efectoAlImpactar(proyectil,elemento) {
        proyectil.mori()
    }
}
//(Proyectil Spiderman)
class Telaraña inherits Bala {
    override method image() = "proyectilTelaraña.png"

    override method aplicarEfectoA(elemento) {
        elemento.inmovilizar()
    }
}
//(Proyectil Goku)
object energia {
    method image() = "bolaEnergiaAzul.png"
    method aplicarEfectoA(elemento) {}
    method efectoAlImpactar(proyectil,elemento) {
        if (elemento.vida() > 0) { 
            proyectil.mori() 
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