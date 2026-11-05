import interfaz.*
import robot.*
import wollok.game.*
import direcciones.*
import etapaDelJuego.*
import generadorAleatorio.*


class Proyectil {
    var property position = game.at(game.width(), game.height() -1)
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

    override method herirA(elemento) {
        elemento.teHirieron()
        elemento.inmovilizarPor(2000)
        self.mori()
    }
}

class Energia inherits Proyectil {
    override method image() = "bolaEnergiaAzul.png"
    override method herirA(elemento) {
      elemento.teHirieron()
    if (elemento.vida() > 0){
        self.mori()
    }
    }
}

object spawnerMunicion {
    method generarMunicion() { 
        const posicionInicial = generadorAleatorio.filaAleatoriaVaciaEnX(1)
        const nuevaMunicion = new Carga(position = posicionInicial)
        game.addVisual(nuevaMunicion) 
        game.schedule(4000, { game.removeVisual(nuevaMunicion) }) //elimina la municion si no se agarro
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