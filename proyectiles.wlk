import robot.*
import wollok.game.*
import direcciones.*
import etapaDelJuego.*
import generadorAleatorio.*

class Bala {
    var property position
    const movimiento = game.tick(130, { // game.tick devuelve un objeto Tick que responde a .start() y .stop()
            self.mover()
        }, false) 

    method image() = "proyectilDisparo.png"

    method moverse() {
        movimiento.start()
        game.onCollideDo(self, { elemento =>
            self.herirA(elemento)
        })
    }

    method mover() {
        if (tablero.dentro(self.position())) {
            position = position.right(1)
        } else {
            self.mori() // Si sale de la pantalla, se destruye
        }
    }

    method mori() {
        movimiento.stop() // Detiene directamente este temporizador
        game.removeVisual(self)
    }

    method herirA(elemento) {
        elemento.teHirieron()
        self.mori() // Si impacta a un enemigo, se destruye
    }
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
        const nuevaMunicion = new Carga(position=posicionInicial)
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

class CargaTelaraña inherits Carga{
    override method image() = "pizza.png" 
}

class CargaSemilla inherits Carga{
    override method image() = "semillaErmitaño.png" 
    
} 
