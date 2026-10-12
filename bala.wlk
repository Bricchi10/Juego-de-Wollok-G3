import robot.*
import wollok.game.*
import direcciones.*

class Bala {
    var property position
    const movimiento = game.tick(130, { // game.tick devuelve un objeto Tick que responde a .start() y .stop()
            self.mover()
        }, false) 

    method esEnemigo() = false

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
        game.sound("muerteRobot.mp3").play()
        self.mori() // Si impacta a un enemigo, se destruye
    }
    method chocarConPersonaje(personaje) {}// nuevo
}

object spawnerMunicion { 
    method generarMunicion() { 
        const filaEntrada = (1 .. 5).anyOne()  
        const posicionInicial = game.at(1, filaEntrada) 
        const nuevaMunicion = new Carga(position=posicionInicial)
        game.addVisual(nuevaMunicion) 
    }
}

class Carga {
    var property position
    method image() = "proyectilDisparo.png" 
    
    method intentarRecargarA(personaje) {
        personaje.recargar()
        game.removeVisual(self)
    }
    method chocarConPersonaje(personaje) {}//nuevo
}
