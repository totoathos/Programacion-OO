import wollok.game.*
import obj.*
import objaa.*

class Enemigo_Corta_Distancia inherits Personajes{
    //Por Default, asignamos que el enemigo global sea de corta distancia
    var property x = 5.randomUpTo(20).truncate(0)
    var property y = 5.randomUpTo(12).truncate(0)
    var property position = game.at(x,y)
    var property visual = game.addVisual(self)
    var property tipo = "enemigo_corto"
    var destino_x = 0
    var destino_y = 0
    var rango = []
    var property numero = ""
    
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
   	
    
    method seguir(heroe){
    	var posicion_heroe = heroe.position()
    	destino_x = position.x() + if(posicion_heroe.x() > position.x()) 1 else -1
    	destino_y = position.y() + if(posicion_heroe.y() > position.y()) 1 else -1
    	
    	if (not(Oleada.comprobar_enemigos())){
    		self.mover(destino_x,destino_y)
    	}
    	
    }
    
    
    method mover(destinox,destinoy){
    	position = game.at(destinox,destinoy)
    }
}

class Proyectil {
	var property position
	const direccion = heroe.position()
	
    method image() = "fuego.jpg"
    
    method impacto(){
    	return(direccion == position)
    }
    
    method ir_hacia_objetivo(){
    	
    	var x =if(direccion.x()>position.x()) 1 else -1
    	var y =if(direccion.y()>position.y()) 1 else -1
    	
    	position = game.at(x,y)
    }
    
    method ataque(){
    }
    
}

class Enemigos_Larga_Distancia inherits Enemigo_Corta_Distancia{
	var property rangos_disparo = []
	
	method disparar(){
		self.check_disparo()
    	game.schedule(500, {const proyectil = new Proyectil(position = self.position())})	
    	
    }
    
    override method image() = "enemigo.jpg"
    
    method anadir_rangos_disparo(){
    	var direcciones = [
        	[position.x()+1, position.y()],
        	[position.x(), position.y()+1],
        	[position.x()-1, position.y()],
        	[position.x(), position.y()-1]
    	]

    	rangos_disparo = []
    	direcciones.forEach{ direccion =>
        	(1..5).forEach{casilla =>
            	rangos_disparo.add(game.at(position.x() + casilla * direccion.get(0), position.y() + casilla * direccion.get(1)))
        		}
    		}
    	}
    	
    method check_disparo(){
    	self.anadir_rangos_disparo()
    	rangos_disparo.forEach{n => if(n == heroe.position()) return true}
    }
}
