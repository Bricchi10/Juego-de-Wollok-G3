import robot.*
import wollok.game.*

class Bala {
    var property position
    var miTick = null 

    method esEnemigo() = false

    method image() = "proyectilDisparo.png"

    method moverse() {
        // game.tick devuelve un objeto Tick que responde a .start() y .stop()
        miTick = game.tick(130, {
            if (position.x() < game.width() - 1) {
                self.mover()
            } else {
                self.destruir() // Si sale de la pantalla, se destruye
            }
        }, true)

        miTick.start()
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
        if (miTick != null) {
            miTick.stop() // Detiene directamente este temporizador
        }
        game.removeVisual(self)
    }
}