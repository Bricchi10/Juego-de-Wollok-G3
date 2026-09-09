object dragon {
  var property position = game.origin()

  method image() = "charizard.png"

  method subir_(numeroDeVeces) {
    position = position.up(numeroDeVeces)
  }
 method posicion(){
    return {position}
  } 
  
}