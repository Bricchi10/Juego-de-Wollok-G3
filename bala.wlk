import robot.*
class Bala {
    var property position
    
    method image(){
        return "proyectilDisparo.png"
    }

    method moverse() {
        game.onTick(130,"movimientoDeBala", {self.mover()})
    }

    method mover(){
        position = position.right(1)
    }

}