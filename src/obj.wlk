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
    	if(self.comprobar_vida(adversario)){
    		adversario.position(game.at(-900,-900))
    		game.removeVisual(adversario)
    		Oleada.cantidad_enemigos().remove(adversario)
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
	
	var visual = game.addVisual(self)
	
	const property tipo = "Jefe"
	
	var property position = game.center()
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
	
	
}

