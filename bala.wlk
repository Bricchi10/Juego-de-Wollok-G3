import robot.*
class Bala {
    var property position
    
    method image(){
        return "proyectilDisparo.png"
    }

    method moverse() {
        game.onTick(130,"movimientoDeBala", {self.mover()})
        
        game.onCollideDo(self, {personaje =>
            if( personaje.esEnemigo() ){
                //game.removeVisual(personaje)
                personaje.teHirieron()
                game.removeVisual(self)
            } 
        })
        //falta dejar de referenciar al robot y a la bala(de alguna manera), para que "mueran" definitivamente
    }

    method mover(){
        position = position.right(1)
    }

}