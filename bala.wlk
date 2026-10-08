import robot.*
import wollok.game.*

class Bala {
    var property position
    const miTick = game.tick(130, { // game.tick devuelve un objeto Tick que responde a .start() y .stop()
            if (position.x() < game.width() - 1) {
                self.mover()
            } else {
                self.destruir() // Si sale de la pantalla, se destruye
            }
        }, false) 

    method esEnemigo() = false

    method image() = "proyectilDisparo.png"

    method moverse() {
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
        miTick.stop() // Detiene directamente este temporizador
        game.removeVisual(self)
    }
}