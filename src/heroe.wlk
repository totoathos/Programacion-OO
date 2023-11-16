import wollok.game.*
import class_personajes.*
import instancias.*
import enemigos.*


class Heroe inherits Personajes{
    var property estamina= 100
    var property estado = "normal"
    var property position = game.center()
    var property rangos = []
    
    method image() = "pj_" + direccion_personaje + ".png"
    
    method aumentar_estamina(){
    	if (estamina < 91){estamina += 20}
    }
    
    method cambiar_direccion(estado_direccion){
    	direccion_personaje = estado_direccion
    	self.definir_rangos()
    	
    }
    
    method definir_rangos(){ 	//Metodo para asignar un rango de ataque
	  rangos.clear()
	  
	  if(direccion_personaje == "arriba"){
	    rangos = [game.at(position.x(),position.y()+1), game.at(position.x(),position.y()+2)]
	  	}
	  
	  if(direccion_personaje == "abajo"){
	    rangos = [game.at(position.x(),position.y()-1), game.at(position.x(),position.y()-2)]
	  	}
	  
	  if(direccion_personaje == "der"){
	    rangos = [game.at(position.x()+1,position.y()), game.at(position.x()+2,position.y())]
	  	}
	 
	  if(direccion_personaje == "izq"){
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
    
    method proteger(){		//Cambia el estado del heroe y su direccion se cambia para que se carguen las texturas adecuadas
        if(direccion_personaje == "arriba"){
        	direccion_personaje = "arriba_cubriendose"
        }
        
        if(direccion_personaje == "abajo"){
        	direccion_personaje = "abajo_cubriendose"
        }
        
        if(direccion_personaje == "der"){
        	direccion_personaje = "der_cubriendose"
        }
        
        if(direccion_personaje == "izq"){
        	direccion_personaje = "izq_cubriendose"
        }
        self.cambiar_estado("protegido")
    }
    
    
    
    method comprobar_ataque(){ //Comprueba si hay un enemigo en el rango de ataque
   		
   		//Se separa en dos variables los objetos que hay en las dos casillas del rango
	   		var buscar1 = game.getObjectsIn(rangos.get(0))
	   		var buscar2 = game.getObjectsIn(rangos.get(1)) 
	
		//Verifica que haya un objeto en alguna de las dos variables y que sea un enemigo 		
		
	    	if (not(buscar1.isEmpty())) {
	    		buscar1.forEach{enemy => 
	    			if(not(enemy.tipo() == "heroe" or (enemy.tipo()=='proyectil'))){enemy.vida(enemy.vida() - dano);	
	    			self.eliminar_adversario(enemy);
	    			return enemy}}
	    	} 
	    		
	    	if (not(buscar2.isEmpty())){
	             buscar2.forEach{enemy =>
	             		if(not(enemy.tipo() == "heroe" or (enemy.tipo()=='proyectil'))){enemy.vida(enemy.vida() - dano);
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
	
	method mover_personaje(destinox,destinoy){
    	self.position(game.at(destinox,destinoy))
    }
    
}
