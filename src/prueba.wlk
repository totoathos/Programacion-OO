class Jefes inherits Personajes{
	
	const position = game.center()
	var rango = []
	
	method image() = "variable.jpg"
	
	method invocar_enemigos(){
		Oleada.crear_enemigos()
	}
	
	method comprobar_atacar(){
		self.anadir_rangos_disparo()
    	rango.forEach{n => if(n == heroe.position()) return true}
	}
	
	override method ataque(enemigo){
		self.comprobar_atacar()
		heroe.vida(heroe.vida()-dano)
	}
	
	method anadir_rangos_disparo(){
    	var direcciones = [
        	[1,0],
        	[0,1],
        	[-1,0],
        	[0,-1]
    	]

    	rango = []
    	direcciones.forEach{ direccion =>
        	(1..5).forEach{casilla =>
            	rango.add(game.at(position.x() + casilla * direccion.get(0), position.y() + casilla * direccion.get(1)))
        		}
    		}
    	}
	
	method pinchos(){
		Oleada.cantidad_enemigos().add(new Puas())
	}
	
}

class Puas{
	var x = 0.randomUpTo(20).truncate(0)
	var y = 0.randomUpTo(20).truncate(0)
	const position = game.at(x,y)
	var dano = 10
	var visual = game.addVisual(self)
	
	
	method comprobar_posicion_jugador(){
		return(position==heroe.position())
	}
	
	method ataque(jugador){
		if((self.comprobar_posicion_jugador()) and (position==jugador.position())){
			(jugador.vida(jugador.vida() - dano))
			self.desaparecer()
		}
	}
	
	method desaparecer(){
		game.removeVisual(self)
		Oleada.cantidad_enemigos().remove(self)
	}
	
}
