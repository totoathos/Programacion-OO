import wollok.game.*
import objaa.*
import enemigos.*
import oleadas.*

const personajes = game.allVisuals()

class Personajes{
    var property vida = 100
    var property dano = 1000
    
    method ataque(entidad){
        entidad.vida(entidad.vida() - dano)
        self.eliminar_adversario(entidad)
        
    }
    
    method comprobar_vida(adversario){
    	return adversario.vida() <= 0
    }
    
    method eliminar_adversario(adversario){
    	var contador = 0
    	var indice = 0
    	if(self.comprobar_vida(adversario)){
    		game.removeVisual(adversario)
    		Oleada.cantidad_enemigos().forEach{enemigo => if(enemigo == adversario){indice = contador} ; contador += 1}
    		Oleada.cantidad_enemigos().remove(adversario)
    		game.removeTickEvent(adversario.numero())
    		if(Oleada.comprobar_enemigos()){Oleada.avanzar_oleadas()}
    	}
    }   
    
}

object menu{
	var property position = game.at(0,0)
	const property blanco = "FFFFFF"
	var property nivel = 1
	var property tipo = "menu"
	
	method sumar_oleada(){
		nivel += 1
	}
	method text() = "Oleada " + nivel
	
	method textColor() = self.blanco()
}



class Jefes inherits Personajes{
	
	var property position = game.center()
	var rango = []
	var property tipo = 'Jefe'
	var visual = game.addVisual(self)
	var property dificultad
	var property numero = ""
	
	method image() = "jefe1.png"
	
	method invocar_enemigos(){
		Oleada.crear_enemigos()
	}
	
	method comprobar_atacar(){
		self.anadir_rangos_disparo()
    	rango.forEach{n => if(n == heroe.position()) return true}
	}
	
	override method ataque(enemigo){
		self.comprobar_atacar()
		if (dificultad==1){
			self.pinchos()
		}
		if (dificultad==1.25){
			self.invocar_enemigos()
		}
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
		Oleada.cantidad_puas().add(new Puas())
	}
	
}

class Puas{
	var property x = 5.randomUpTo(20).truncate(0)
    var property y = 5.randomUpTo(12).truncate(0)
	var property position = game.at(x,y)
	var property tipo = 'Puas'
	var dano = 10
	var visual = game.addVisual(self)
	
	method image() = "spike_4.png"
	
	method comprobar_posicion_jugador(){
		return(position==heroe.position())
	}
	
	
	method ataque(jugador){
		if((self.comprobar_posicion_jugador()) and (position==jugador.position())){
			(jugador.vida(jugador.vida() - dano))
			console.println(heroe.vida())
			self.desaparecer()
		}
	}
	
	method desaparecer(){
		game.removeVisual(self)
		Oleada.cantidad_puas().remove(self)
	}
	
}

