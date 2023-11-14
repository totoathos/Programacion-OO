import objaa.*
import wollok.game.*

class Oleadas{
	var property cantidad_enemigos = []
	var property cantidad_jefes = []
	var property cantidad_puas= []
	var generador_enemigos = 1.randomUpTo(2).truncate(0)
	var dificultad = 1
	var property nivel = 1
	
	//comprueba el nivel de la oleada para luego aumentar la dificultad automaticamente
	method comprobar_nivel(){
		if(nivel<=4){
			dificultad = 1
			return "Principiante"
		}
		
		
		if(5<nivel and nivel<=10){
			dificultad = 1.25
			return "intermedio"
		}
		
		nivel = 1
		return " "
	}
	
	method comprobar_enemigos(){
		return cantidad_enemigos.isEmpty()
	}
	
	method avanzar_oleadas(){
			nivel += 1
			if(not(nivel == 5 or nivel ==10)){
				Menu.sumar_oleada()
				self.crear_enemigos()
			}
			if((self.comprobar_enemigos()) and cantidad_jefes.isEmpty()){
				Menu.sumar_oleada()
				self.crear_enemigos()
			}
			
		
	}
	
	//para crear los enemigos evaluamos la oleada para determinar la dificultad
	method crear_enemigos(){
		var contador = 0
		(1 .. generador_enemigos).forEach{n => const numero_a = contador.toString() + "a"; const numero_b = contador.toString() + "b" ; cantidad_enemigos.add(new Enemigos_Larga_Distancia(numero = numero_a , vida = 75*dificultad,dano = 30*dificultad,tipo="enemigo_largo")); cantidad_enemigos.add(new Enemigo_Corta_Distancia(numero= numero_b ,vida = 75*dificultad,dano = 30*dificultad,tipo="enemigo_corto"))}
		cantidad_enemigos.forEach{n => game.addVisual(n)}
		cantidad_enemigos.forEach{n=> game.onTick(1600.randomUpTo(2100), n.numero(), {n.seguir(heroe) ; if(n.position()==heroe.position()){n.ataque(heroe)}})}
		
		if(nivel == 5 or nivel == 10){
			cantidad_jefes.add(new Jefes(vida=200, dano=50, dificultad=dificultad))
			}
	

}

}



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
	
	var property position = game.at(10,10)
	var rango = []
	var property tipo = 'Jefe'
	var visual = game.addVisual(self)
	var property dificultad
	var property numero = ""
	
	method image() = "jefe1.png"
	
	
	method comprobar_atacar(){
		self.anadir_rangos_disparo()
    	rango.forEach{n => if(n == heroe.position()) return true}
	}
	
	override method ataque(heroee){
		self.comprobar_atacar()
		if (dificultad==1 or dificultad==1.25){
			self.pinchos()
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


class Enemigo_Corta_Distancia inherits Personajes{
    //Por Default, asignamos que el enemigo global sea de corta distancia
    var property x = [0, 28].anyOne()
    var property y = 2.randomUpTo(10).truncate(0)
    var property position = game.at(x,y)
    var property tipo = "enemigo_corto"
    var property direccion = "der"
    var property numero = ""
    
    method image() = "enemigo1_"+ direccion +".png"
    
    override method eliminar_adversario(adversario){
    	if(self.comprobar_vida(adversario)){
    		game.stop()
    	}
    }
    
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
   		if(entidad.direccion()=="der"){entidad.mover(entidad.position().x() - 1, entidad.position().y())} ; 
        if(entidad.direccion()=="izq"){entidad.mover(entidad.position().x() + 1, entidad.position().y())} ; 
        if(entidad.direccion()=="arriba"){entidad.mover(entidad.position().x(), entidad.position().y() + 1)} ; 
        if(entidad.direccion() == "bajo"){entidad.mover(entidad.position().x(), entidad.position().y() - 1)}
   	}
   	
    
    method seguir(entidad){
    	var posicion_entidad = entidad.position()
    	
    	if(posicion_entidad.x() > position.x()){
    		self.mover(position.x() + 1, position.y())
    		direccion = "der"
    	}
    	
    	else if(posicion_entidad.x() < position.x()){
    		self.mover(position.x() - 1, position.y())
    		direccion = "izq"
    	}
    	
    	else if(posicion_entidad.y() > position.y()){
    		self.mover(position.x(), position.y() + 1)
    		direccion = "arriba"
    	}
    	
    	else {
    		self.mover(position.x(), position.y() - 1)
    		direccion = "bajo"
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
	var imagen = ""
	var property lanzado = false
    var property numero = ""
   
    method image() = "fuego.png"
    
    
    
   	method cambiar_direccion(nueva_orientacion){
   		direccion = nueva_orientacion
   	}
   
   	method cambiar_posicion(nueva_posicion){
   		position = nueva_posicion
   	}
   
   	method avanzar(){
   		
   		if(direccion == "der"){
   			self.position(position.right(1))
   			imagen = "D"
   		}
   		
   		if(direccion == "izq"){
   			self.position(position.left(1))
   			imagen = "I"
   		}
   		
   		if(direccion == "arriba"){
   			self.position(position.up(1))
   			imagen = "Ar"
   			
   		}

   		if(direccion == "bajo"){
   			self.position(position.down(1))
   			imagen = "Ab"
   			
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
   				if(entidad.vida() <= 0){
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
			game.onTick(250, "movimiento", {proyectil.avanzar()})
			proyectil.lanzado(true)
		}
    
    }
    
    override method image() =  "enemigo2_"+ direccion +".png"
}


class Heroe inherits Personajes{
    var property estamina= 50
    var property estado = "normal"
    var property position = game.center()
    const property tipo = "heroe"
    var property rangos = []
    var property direccion = "der"
    
    method image() = "pj_" + direccion + ".png"
    
    method aumentar_estamina(){
    	if (estamina <= 91){estamina += 10}
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
  			}	
	}
	
	method mover(destinox,destinoy){
    	self.position(game.at(destinox,destinoy))
    }
	
	
    
}
