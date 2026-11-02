import robot.*
import wollok.game.*
import direcciones.*
import etapaDelJuego.*
import generadorAleatorio.*


class Proyectil {
    var property position = game.origin()
    const movimiento = game.tick(100, { self.mover() }, false)
    const property disparador

    method image()

    method disparate() {
        position = disparador.position().right(1)
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
    }

    method herirA(elemento) {
        elemento.teHirieron()
        self.mori() // Si impacta a un enemigo, se destruye
    }

    method verificarSiEstaFueraDelTablero() {
        if (not tablero.dentro(self.position())) {
            self.mori() // Si sale de la pantalla, se destruye
        }
    }

    method teHirieron() { }
}

class Bala inherits Proyectil {
    override method image() = "proyectilDisparo.png"
}

class Telaraña inherits Proyectil {
    override method image() = "proyectilTelaraña.png"
}

class Energia inherits Proyectil {
    override method image() = "bolaEnergiaAzul.png"
}

object spawnerMunicion {
    method generarMunicion() { 
        const posicionInicial = generadorAleatorio.filaAleatoriaVaciaEnX(1)
        const nuevaMunicion = new Carga(position = posicionInicial)
        game.addVisual(nuevaMunicion) 
    }
}

class Carga {
    var property position
    method image() = etapaDelJuego.personajePrincipal().imagenCarga()
    
    method chocarConPersonaje(personaje) {
        personaje.recargar()
        game.removeVisual(self)
        game.sound(personaje.sonidoCarga()).play()
    }
}