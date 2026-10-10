import robot.*
import wollok.game.*

class Bala {
    var property position
    const movimiento = game.tick(130, { // game.tick devuelve un objeto Tick que responde a .start() y .stop()
            self.mover()
        }, false) 

    method esEnemigo() = false

    method image() = "proyectilDisparo.png"

    method moverse() {
        miTick.start()
        game.onCollideDo(self, { personaje =>
            personaje.teHirieron()
            game.sound("muerteRobot.mp3").play()
            self.mori() // Si impacta a un enemigo, se destruye
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
}