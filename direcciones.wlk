import game.*
object tablero {
    
    method validarDentro(position) {
        if (not self.dentro(position)) {
            self.error(position.toString() + " no está dentro del tablero ")
        }
    }

    method dentro(position) {
        return position.x().between(0, game.width() -1) and position.y().between(1, game.height() -2 )
    }
}

object moverEnDireccion {

    method siguiente(positionAMover) {
        const nueva = positionAMover
        tablero.validarDentro(nueva)
        return nueva
    }
}