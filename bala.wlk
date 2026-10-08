import robot.*
import wollok.game.*
import direcciones.*
class Bala {
    var property position
    const movimiento = game.tick(130, { // game.tick devuelve un objeto Tick que responde a .start() y .stop()
            if (tablero.dentro(self.position())) {
                self.mover()
            } else {
                self.destruir() // Si sale de la pantalla, se destruye
            }
        }, false) 

    method esEnemigo() = false

    method image() = "proyectilDisparo.png"

    method moverse() {
        movimiento.start()
        game.onCollideDo(self, { personaje =>
            if (personaje.esEnemigo()) {
                personaje.teHirieron()
                game.sound("muerteRobot.mp3").play()
                self.destruir() // Si impacta a un enemigo, se destruye
            }
        })
    }

    method mover() {
        position = position.right(1)
    }

    method destruir() {
        movimiento.stop() // Detiene directamente este temporizador
        game.removeVisual(self)
    }
}