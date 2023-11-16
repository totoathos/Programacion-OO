import wollok.game.*
import obj.*
import objaa.*

class Enemigo_Corta_Distancia inherits Personajes{
    //Por Default, asignamos que el enemigo global sea de corta distancia
    var property x = [0, 28].anyOne()
    var property y = 2.randomUpTo(10).truncate(0)
    var property position = game.at(x,y)
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
	var imagen = "der"
	var property lanzado = false
    var property id
   
    method image() = "fuego_" + imagen + ".png"
    
    
    
   	method cambiar_direccion(nueva_orientacion){
   		direccion = nueva_orientacion
   	}
   
   	method cambiar_posicion(nueva_posicion){
   		position = nueva_posicion
   	}
   
   	method avanzar(){
   		
   		if(direccion == "der"){
   			self.position(position.right(1))
   			imagen = "der"
   		}
   		
   		if(direccion == "izq"){
   			self.position(position.left(1))
   			imagen = "izq"
   		}
   		
   		if(direccion == "arriba"){
   			self.position(position.up(1))
   			imagen = "arriba"
   			
   		}

   		if(direccion == "bajo"){
   			self.position(position.down(1))
   			imagen = "bajo"
   			
   		}

   	}
   	
   	method comprobacion(){
   		
   		if(self.position().x() > game.width() - 1 or
   		   self.position().x() < 0 				  or
   		   self.position().y() > game.height() - 1 or
   		   self.position().y() < 0)
   		   		{self.eliminar()}
   	}
   	   
	   
   	method eliminar(){
   		lanzado = false		
   		self.cambiar_posicion(game.at(0,0))
   		game.removeVisual(self)
   		game.removeTickEvent('Avanzando' + id.toString())
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
	
	var identificador = 0
	
	method disparar(){
		const proyectil = new Proyectil(position = position, direccion = direccion, id=identificador)
		if (not(proyectil.lanzado())){
			proyectil.iniciar_disparo(position, direccion)
			game.onTick(250, 'Avanzando' + identificador.toString() , {proyectil.avanzar() ; proyectil.comprobacion()})
			proyectil.lanzado(true)
			identificador += 1
		}
    
    }
    
    override method image() =  "enemigo2_"+ direccion +".png"
}


class Jefes inherits Personajes{
	
	var property position = game.at(10,10)
	var rango = []
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
