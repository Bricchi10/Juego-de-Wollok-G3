import direcciones.*
import robot.*
class Bala {
    var property position
    
    method image(){
        return "proyectilDisparo.png"
    }

    method moverse() {
        game.onTick(130,"movimientoDeBala", {self.mover()})
        
        game.onCollideDo(self, {robot =>  //tambien reconoce a terminator como robot por estar en la misma celda
        spawnerRobots.eliminarRobot(robot)
        game.removeVisual(self) })
        //falta dejar de referenciar al robot y a la bala(de alguna manera), para que "mueran" definitivamente
    }

    method mover(){
        position = derecha.siguiente(position)
        if (position.x() == game.width() -1) {
            game.removeVisual(self)
        }
    }

}