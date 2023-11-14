import wollok.game.*
import obj.*
import objaa.*

class Enemigo_Corta_Distancia inherits Personajes{
    //Por Default, asignamos que el enemigo global sea de corta distancia
    var property x = 5.randomUpTo(20).truncate(0)
    var property y = 5.randomUpTo(12).truncate(0)
    var property position = game.at(x,y)
    var property tipo = "enemigo_corto"
    var property direccion = "derecha"
    var destino_x = 0
    var destino_y = 0
    var rango = []
    
    method image() = "enemigo1.jpg"
    
    //comprueba que si el heroe esta protegido para sacar estamina o vida
    override method ataque(entidad){
        if (entidad.estado() == "protegido"){
            entidad.estamina(entidad.estamina()-10)
        }
        entidad.vida(entidad.vida() - dano)
        entidad.cambiar_estado("danado")
        self.alejar(entidad)
    }
    
   	method alejar(entidad){
   		if(entidad.direccion()=="Derecha"){entidad.mover(entidad.position().x() + 1, entidad.position().y())} ; 
        if(entidad.direccion()=="Izquierda"){entidad.mover(entidad.position().x() - 1, entidad.position().y())} ; 
        if(entidad.direccion()=="Arriba"){entidad.mover(entidad.position().x(), entidad.position().y() - 1)} ; 
        if(entidad.direccion() == "Abajo"){entidad.mover(entidad.position().x(), entidad.position().y() + 1)}
   	}
   	
    
    method seguir(entidad){
    	var posicion_entidad = entidad.position()
    	
    	if(posicion_entidad.x() > position.x()){
    		self.mover(position.x() + 1, position.y())
    		direccion = "derecha"
    	}
    	
    	else if(posicion_entidad.x() < position.x()){
    		self.mover(position.x() - 1, position.y())
    		direccion = "izquierda"
    	}
    	
    	else if(posicion_entidad.y() > position.y()){
    		self.mover(position.x(), position.y() + 1)
    		direccion = "arriba"
    	}
    	
    	else {
    		self.mover(position.x(), position.y() - 1)
    		direccion = "abajo"
    	}
    }
    
    
    method mover(destinox,destinoy){
    	position = game.at(destinox,destinoy)
    }
}

class Proyectil {
	var property position
	const dano = 10
	var direccion 
	var property tipo = "proyectil"
	var property lanzado = false
    method image() = "fuego.png"
    
    
    
   	method cambiar_direccion(nueva_orientacion){
   		direccion = nueva_orientacion
   	}
   
   	method cambiar_posicion(nueva_posicion){
   		position = nueva_posicion
   	}
   
   	method avanzar(){
   		
   		if(direccion == "derecha"){
   			self.position(position.right(1))
   		}
   		
   		if(direccion == "izquierda"){
   			self.position(position.left(1))
   		}
   		
   		if(direccion == "arriba"){
   			self.position(position.up(1))
   		}

   		if(direccion == "abajo"){
   			self.position(position.down(1))
   		}

   	}
   	
   	method comprobacion(){
   		
   		if(self.position().x() > game.width() - 1 or
   		   self.position().x() < 0 				  or
   		   self.position().y() > game.height() 	  or
   		   self.position().y() < 0)
   		   		{self.eliminar()}
   	}
   	   
	   
   	method eliminar(){
   		lanzado = false		
   		self.cambiar_posicion(game.at(0,0))
   		game.removeVisual(self)
   		
   	}
   
   	method iniciar_disparo(posicion, orientacion){
   		game.addVisual(self)
   		self.cambiar_direccion(orientacion)
   		self.cambiar_posicion(posicion)
   		game.onCollideDo(self, {entidad =>
   			if(entidad.tipo() == "heroe"){
   				entidad.vida(entidad.vida() - dano)	
   				self.eliminar()
   				if(entidad.vida() < 0){
   					game.stop()
   					
   					}
   			}
   		})
   	}
    
}



class Enemigos_Larga_Distancia inherits Enemigo_Corta_Distancia{
	
	method disparar(){
		const proyectil = new Proyectil(position = position, direccion = direccion)
		if (not(proyectil.lanzado())){
			proyectil.iniciar_disparo(position, direccion)
			game.onTick(500, "movimiento", {proyectil.avanzar()})
			proyectil.lanzado(true) 
			
		}
    	
    }
    
    override method image() = "enemigo.jpg"
}
