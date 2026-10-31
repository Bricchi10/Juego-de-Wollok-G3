import robot.*
import wollok.game.*
import direcciones.*
import etapaDelJuego.*
import generadorAleatorio.*

class Bala {
    var property position
    const movimiento = game.tick(100, { position = position.right(1) }, false) 

    method image() = "proyectilDisparo.png"

    method moverse() {
        movimiento.start()
    }

    method mori() {
        movimiento.stop()
        game.removeVisual(self)
    }

    method herirA(elemento) {
        elemento.teHirieron()
        self.mori() // Si impacta a un enemigo, se destruye
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