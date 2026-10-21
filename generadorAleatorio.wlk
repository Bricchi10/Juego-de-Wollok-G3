import wollok.game.*
object generadorAleatorio {
		
	method filaAleatoria() {
		return (1 .. 5).anyOne()
	}
	
	method filaAleatoriaVaciaEnX(x) {
		const position = game.at(x, self.filaAleatoria())
		if(game.getObjectsIn(position).isEmpty()) {
			return position	
		}
		else {
			return self.filaAleatoriaVaciaEnX(x)
		}
	}

	
	
}