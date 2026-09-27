import direcciones.*
object robot{
    method position(){
        return game.at(1,3)
    }
    method image(){
        return "robot.png"
    }

}

class RobotNormal{
    var property position = game.at( 10, 2) //esto luego deberia cambiar para aparecer en celdas distintas

    method image(){
        return "robot.png"
    }

    method mueveIzquierda(){
        const nuevaPosicion = izquierda.siguiente( self.position())
        position = nuevaPosicion
    } 
}
