
object caballero {
  var property position = game.origin()

  method image() = "guts.png"

  method subir_(numeroDeVeces) {
    position = position.up(numeroDeVeces)
  }
  method posicion(){
    return {position}
  } 
}