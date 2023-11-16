import wollok.game.*
import class_personajes.*
import instancias.*
import enemigos.*


class Heroe inherits Personajes{
    var property estamina= 100
    var property estado = "normal"
    var property position = game.center()
    const property tipo = "heroe"
    var property rangos = []
    var property direccion = "der"
    
    method image() = "pj_" + direccion + ".png"
    
    method aumentar_estamina(){
    	if (estamina < 91){estamina += 20}
    }
    
    method cambiar_direccion(estado_direccion){
    	direccion = estado_direccion
    	self.definir_rangos()
    	
    }
    
    method definir_rangos(){
	  rangos.clear()
	  
	  if(direccion == "arriba"){
	    rangos = [game.at(position.x(),position.y()+1), game.at(position.x(),position.y()+2)]
	  }
	  
	  if(direccion == "abajo"){
	  	//rangos = [[position.x(),position.y()-1], [position.x(),position.y()-2]]
	    rangos = [game.at(position.x(),position.y()-1), game.at(position.x(),position.y()-2)]
	  
	  }
	  
	  if(direccion == "der"){
	  	
	    rangos = [game.at(position.x()+1,position.y()), game.at(position.x()+2,position.y())]
	  	}
	  
	  if(direccion == "izq"){
	    rangos = [game.at(position.x()-1,position.y()), game.at(position.x()-2,position.y())]
	  	}
	  
    }
    
    method cambiar_estado(nuevo_estado){
    	estado = nuevo_estado
    }
    
    method comprobar_estamina(){
        return estamina < 10  
    }
    
    method comprobar_estado(){
    	return estado
    }
    
    method proteger(){
        if(direccion == "arriba"){
        	direccion = "arriba_cubriendose"
        }
        
        if(direccion == "abajo"){
        	direccion = "abajo_cubriendose"
        }
        
        if(direccion == "der"){
        	direccion = "der_cubriendose"
        }
        
        if(direccion == "izq"){
        	direccion = "izq_cubriendose"
        }
        self.cambiar_estado("protegido")
    }
    
    
    
    method comprobar_ataque(){
   		
	   		var buscar1 = game.getObjectsIn(rangos.get(0))
	   		var buscar2 = game.getObjectsIn(rangos.get(1))
	   		
	    	if (not(buscar1.isEmpty())) {
	    		buscar1.forEach{enemy => 
	    			if(not(enemy.tipo() == "heroe")){enemy.vida(enemy.vida() - dano);
	    			self.eliminar_adversario(enemy);
	    			return enemy}}
	    	} 
	    		
	    	if (not(buscar2.isEmpty())){
	             buscar2.forEach{enemy =>
	             	if(not(enemy.tipo() == "heroe")){enemy.vida(enemy.vida() - dano);
	    			self.eliminar_adversario(enemy);
	    			return enemy}
	    			}}
	    	}
    	

    method ataque(){
    	
    	if(self.comprobar_estado() == "normal"){
    		
    		self.cambiar_estado("atacando")
    		self.comprobar_ataque()
  			}	
	}
	
	method mover(destinox,destinoy){
    	self.position(game.at(destinox,destinoy))
    }
	
	
    
}
