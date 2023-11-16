import wollok.game.*
import class_personajes.*
import instancias.*

class Enemigo_Corta_Distancia inherits Personajes{
    
    //Por Default, asignamos que el enemigo global sea de corta distancia
    
    var property x = [0, 28].anyOne()  	//Se elige de manera "aleatoria" una posicion del eje X
    var property y = 2.randomUpTo(10).truncate(0)
    var property position = game.at(x,y)
    var property id_tick = "" 		//Identificador para generar un tick propio
    
    method image() = "enemigo1_"+ direccion_personaje +".png"
    
    override method eliminar_adversario(adversario){
    	if(self.comprobar_vida(adversario)){
    		game.stop()
    	}
    }
    
    //comprueba que si el heroe esta protegido para sacar estamina o vida
    override method ataque(entidad){
        if (entidad.estado() == "protegido" and entidad.estamina() > 10){
            entidad.estamina(entidad.estamina()-10)
            entidad.vida(entidad.vida() - (dano / 2))
        	}
        	
        else{
        	entidad.vida(entidad.vida() - dano)
        	entidad.cambiar_estado("danado")
        	self.alejar(entidad)
        	}
        	
   		self.eliminar_adversario(entidad)
    	
    	}
    
   	method alejar(entidad){		//Metodo que se usa para alejar al heroe una vez es golpeado
   		if(entidad.direccion_personaje()=="der"){entidad.mover_personaje(entidad.position().x() - 1, entidad.position().y())} ; 
        if(entidad.direccion_personaje()=="izq"){entidad.mover_personaje(entidad.position().x() + 1, entidad.position().y())} ; 
        if(entidad.direccion_personaje()=="arriba"){entidad.mover_personaje(entidad.position().x(), entidad.position().y() + 1)} ; 
        if(entidad.direccion_personaje() == "bajo"){entidad.mover_personaje(entidad.position().x(), entidad.position().y() - 1)}
   	}
   	
    
    method seguir(entidad){		//Metodo hecho para seguir al heroe, se mueve en horizontal y vertical
    	var posicion_entidad = entidad.position()
    	
    	if(posicion_entidad.x() > position.x()){
    		self.mover_personaje(position.x() + 1, position.y())
    		direccion_personaje = "der"
    	}
    	
    	else if(posicion_entidad.x() < position.x()){
    		self.mover_personaje(position.x() - 1, position.y())
    		direccion_personaje = "izq"
    	}
    	
    	else if(posicion_entidad.y() > position.y()){
    		self.mover_personaje(position.x(), position.y() + 1)
    		direccion_personaje = "arriba"
    	}
    	
    	else {
    		self.mover_personaje(position.x(), position.y() - 1)
    		direccion_personaje = "bajo"
    	}
    }
    
    
    method mover_personaje(destinox,destinoy){
    	position = game.at(destinox,destinoy)
    }
}

class Proyectil {
	var property position
	const dano = 10
	var direccion 
	var property tipo = "proyectil"
	var direccion_imagen = "der"
	var property lanzado = false
    var property id
   
    method image() = "fuego_" + direccion_imagen + ".png"
    
    
    
   	method cambiar_direccion(nueva_orientacion){
   		direccion = nueva_orientacion
   	}
   
   	method cambiar_posicion(nueva_posicion){
   		position = nueva_posicion
   	}
   
   	method avanzar(){
   		
   		if(direccion == "der"){
   			self.position(position.right(1))
   			direccion_imagen = "der"
   		}
   		
   		if(direccion == "izq"){
   			self.position(position.left(1))
   			direccion_imagen = "izq"
   		}
   		
   		if(direccion == "arriba"){
   			self.position(position.up(1))
   			direccion_imagen = "arriba"
   			
   		}

   		if(direccion == "bajo"){
   			self.position(position.down(1))
   			direccion_imagen = "bajo"
   			
   		}

   	}
   	
   	method comprobacion(){		//Comprueba si el proyectil se fue del tablero, en ese caso lo elimina
   		
   		if(self.position().x() > game.width() - 1 or
   		   self.position().x() < 0 				  or
   		   self.position().y() > game.height() - 1 or
   		   self.position().y() < 0)
   		   		{self.eliminar()}
   	}
   	   
	   
   	method eliminar(){		//Se elimina el proyectil del tablero y se remueve su tick
   		lanzado = false		
   		self.cambiar_posicion(game.at(0,0))
   		game.removeVisual(self)
   		game.removeTickEvent('Avanzando' + id.toString())
   	}
   
   	method iniciar_disparo(posicion, orientacion){		//Es el metodo usado para iniciar el disparo del proyectil
   		game.addVisual(self)				
   		self.cambiar_direccion(orientacion)
   		self.cambiar_posicion(posicion)
   		game.onCollideDo(self, {entidad => 	//En caso que colisione y la entidad sea el heroe le hace daño, se condiciona si es que el heroe esta protegido o no 
   			if(entidad.tipo() == "heroe"){
   				if(entidad.estado() == "protegido" and entidad.estamina() > 10){entidad.estamina(entidad.estamina()-10) ; entidad.vida(entidad.vida() - (dano / 2))}
   				else{entidad.vida(entidad.vida() - dano)}	
   				self.eliminar()				//Al hacer contacto se elimina a si mismo
   				if(entidad.vida() <= 0){
   					game.stop()				//Detiene el juego si es que el heroe llega a morir
   					
   				  }
   			   }
   			})
   		}

    
}



class Enemigos_Larga_Distancia inherits Enemigo_Corta_Distancia{
	
	var identificador = 0.randomUpTo(1000) //Identificador creado para darle un tick propio a los proyectiles, facilitando su eliminacion
	
	method disparar(){
		const proyectil = new Proyectil(position = position, direccion = direccion_personaje, id=identificador)
		if (not(proyectil.lanzado())){
			proyectil.iniciar_disparo(position, direccion_personaje)
			game.onTick(250, 'Avanzando' + identificador.toString() , {proyectil.avanzar() ; proyectil.comprobacion()})
			proyectil.lanzado(true)
			identificador += 1
		}
    
    }
    
    override method image() =  "enemigo2_"+ direccion_personaje +".png"
}


class Jefes inherits Personajes{
	
	var property position = game.at(10,10)
	var rango = []
	var visual = game.addVisual(self)
	var property dificultad
	
	method image() = "jefe1.png"
	
	
	method comprobar_ataque(){
		self.anadir_rangos_disparo()
    	rango.forEach{n => if(n == heroe.position()) return true}
	}
	
	override method ataque(heroee){
		self.comprobar_ataque()
		if (dificultad==1 or dificultad==1.25){  	//Genera puas en caso que la dificultad sea la requerida
			self.generar_puas()
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
            	rango.add(game.at(position.x() + casilla * direccion_personaje.get(0), position.y() + casilla * direccion_personaje.get(1)))
        		}
    		}
    	}

	method generar_puas(){
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
		if((self.comprobar_posicion_jugador())){
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
