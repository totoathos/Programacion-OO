import wollok.game.*
import obj.*
import objaa.*
import enemigos.*


class Heroe inherits Personajes{
    var property estamina= 50
    var property estado = "normal"
    var property position = game.center()
    const property tipo = "heroe"
    var property rangos = []
    var property direccion = "Abajo"
    
    method image() = "pj.jpg"
    
    method aumentar_estamina(){
    	if (estamina <= 91){estamina += 10}
    }
    
    method cambiar_direccion(estado_direccion){
    	direccion = estado_direccion
    	self.definir_rangos()
    	
    }
    
    method definir_rangos(){
	  rangos.clear()
	  
	  if(direccion == "Arriba"){
	    rangos = [game.at(position.x(),position.y()+1), game.at(position.x(),position.y()+2)]
	  }
	  
	  if(direccion == "Abajo"){
	  	//rangos = [[position.x(),position.y()-1], [position.x(),position.y()-2]]
	    rangos = [game.at(position.x(),position.y()-1), game.at(position.x(),position.y()-2)]
	  
	  }
	  
	  if(direccion == "Derecha"){
	  	
	    rangos = [game.at(position.x()+1,position.y()), game.at(position.x()+2,position.y())]
	  	}
	  
	  if(direccion == "Izquierda"){
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
        self.cambiar_estado("protegido")
    }
    
    method ataque_especial(enemigo){
        self.comprobar_estamina()
        estamina -= 10
        return enemigo.vida((enemigo.vida()-(dano * 1.5)))
    }
    
    method comprobar_ataque(){
   		
   		var buscar1 = game.getObjectsIn(rangos.get(0))
   		var buscar2 = game.getObjectsIn(rangos.get(1))
		//if((rangos.contains(enemigo.x())) and position.y() == enemigo.y() or (rangos.contains(enemigo.y())) and position.x() == enemigo.x()){console.println("atacando");enemigo.vida(enemigo.vida() - dano)}
    	if (not(buscar1.isEmpty())) {
    		buscar1.forEach{enemy => 
    			enemy.vida(enemy.vida() - dano);
    			self.eliminar_adversario(enemy);
    			return enemy
    	}
    	
    	} 
    	if (not(buscar2.isEmpty())){
             buscar2.forEach{enemy => 
             	enemy.vida(enemy.vida() - dano);
    			self.eliminar_adversario(enemy);
    			return enemy
    		}
    	}
    	}
    	

    method ataque(){
    	
    	if(self.comprobar_estado() == "normal"){
    		
    		self.cambiar_estado("atacando")
    		self.comprobar_ataque()
  			//self.eliminar_adversario(entidad)
  			}		
	}
	
	method mover(destinox,destinoy){
    	self.position(game.at(destinox,destinoy))
    }
	
	
    
}
