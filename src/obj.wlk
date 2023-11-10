import wollok.game.*
import objaa.*
import enemigos.*

const personajes = game.allVisuals()

class Personajes{
    var property vida = 100
    var property dano = 50
    
    method ataque(entidad){
        entidad.vida(entidad.vida() - dano)
        self.eliminar_adversario(entidad)
        
    }
    
    method comprobar_vida(adversario){
    	return adversario.vida() <= 0
    }
    
    method eliminar_adversario(adversario){
    	if(self.comprobar_vida(adversario)){
    		Oleada.cantidad_enemigos().remove(adversario)
    		game.removeVisual(adversario)
    	}
    }   
    
}

class Jefes inherits Personajes{
	
	const position = game.center()
	var rango = [game.at(position.x()-1,position.y()), game.at(position.x()-2,position.y()),game.at(position.x()+1,position.y()), game.at(position.x()+2,position.y()), game.at(position.x(),position.y()+1), game.at(position.x(),position.y())+2, game.at(position.x(),position.y()-1), game.at(position.x(),position.y()-2)]
	
	method image() = "variable.jpg"
	
	method invocar_enemigos(){
		Oleada.crear_enemigos()
	}
	
	
	method comprobar_ataque(){
   		var buscar_heroe = game.getObjectsIn(rango)
    	if (not(buscar_heroe.isEmpty())){
    		buscar_heroe.forEach{heroe=> 
    			heroe.vida(heroe.vida() - dano);
    			self.eliminar_adversario(heroe);
    			return heroe}
    	}
	}
	
}

