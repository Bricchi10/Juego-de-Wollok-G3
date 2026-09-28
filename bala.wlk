import robot.*
class Bala {
    var property position
    
    method image(){
        return "proyectilDisparo.png"
    }

    method moverse() {
        game.onTick(130,"movimiento de bala", {self.mover()})
    }

    method mover(){
        if(position!=robot.position()){
        position = position.right(1)
        }else{
            robot.teHirieron()
            game.removeVisual(self)
        }
    }

}