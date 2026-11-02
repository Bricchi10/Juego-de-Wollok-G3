import robot.*
import wollok.game.*
import direcciones.*
import etapaDelJuego.*
import generadorAleatorio.*

class Bala {
    var property position
    const movimiento = game.tick(100, { self.mover() }, false) 

    method image() = "proyectilDisparo.png"

    method moverse() {
        movimiento.start()
    }

    method mover() {
        position = position.right(1)
        self.verificarSiEstaFueraDelTablero()
    }

    method mori() {
        movimiento.stop()
        game.removeVisual(self)
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

class Telaraña inherits Bala{
    override method image() = "proyectilTelaraña.png"
}

class Energia inherits Bala{
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