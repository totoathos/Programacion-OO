import wollok.game.*
import obj.*
import objaa.*

class Enemigo_Corta_Distancia inherits Personajes{
    //Por Default, asignamos que el enemigo global sea de corta distancia
    var property x = 5.randomUpTo(20).truncate(0)
    var property y = 5.randomUpTo(12).truncate(0)
    var property position = game.at(x,y)
    const property tipo = "enemigo"
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
   	
    
    method seguir(heroe){
    	var posicion_heroe = heroe.position()
    	destino_x = position.x() + if(posicion_heroe.x() > position.x()) 1 else -1
    	destino_y = position.y() + if(posicion_heroe.y() > position.y()) 1 else -1
    	
    	self.mover(destino_x,destino_y)
    }
    
    
    method mover(destinox,destinoy){
    	position = game.at(destinox,destinoy)
    }
}
class Proyectil inherits Enemigo_Corta_Distancia{
	override method ataque(entidad){
    	if (entidad.estado() == "protegido"){
            entidad.estamina(entidad.estamina()-10)
            }
        entidad.vida(entidad.vida() - dano)
        
    }
    override method image() = "fuego.jpg"
}

class Enemigos_Larga_Distancia inherits Enemigo_Corta_Distancia{

    method disparar(enemigo){
    	var posicion_heroe = heroe.position()
    	(enemigo.position(x)).forEach{n => if(posicion_heroe.x() > n){game.addVisual(proyectil)}}
    }
    
    override method ataque(entidad){
    	if (entidad.estado() == "protegido"){
            entidad.estamina(entidad.estamina()-10)
            }
        entidad.vida(entidad.vida() - dano)
        
    }
    override method image() = "enemigo.jpg"
    
}
