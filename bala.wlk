import direcciones.*
import robot.*
class Bala {
    var property position
    method esEnemigo()= false
    
    method image(){
        return "proyectilDisparo.png"
    }

    method moverse() {
    const tickActual = "movimientoDeBala_" + self.identity().toString()

        game.onTick(130, tickActual,{
            if (position.x() <= game.width() - 1) { 
                self.mover() 
            } 
            else {  
                game.removeTickEvent(tickActual) 
                game.removeVisual(self) }
        })
        
        game.onCollideDo(self, {personaje =>
            if( personaje.esEnemigo() ){
                //game.removeVisual(personaje)
                personaje.teHirieron()
                game.removeVisual(self)
                game.sound("muerteRobot.mp3").play()
            } 
        })
        //falta dejar de referenciar al robot y a la bala(de alguna manera), para que "mueran" definitivamente
    }

    method mover(){
        position = derecha.siguiente(position)
        if (position.x() == game.width() -1) {
            game.removeVisual(self)
        }
    }

}