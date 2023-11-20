import wollok.game.*
import instancias.*
import enemigos.*
import oleadas.*

const personajes = game.allVisuals()

class Personajes{
    var property vida = 100
    var property dano = 35
    var property tipo
    var property direccion_personaje = "der"
    var property eliminable = false
    
    method ataque(entidad){					// Metodo que luego de atacar envia el mensaje para que el enemigo se elimine
        entidad.vida(entidad.vida() - dano)
        self.eliminar_adversario(entidad)
        
    }
    
    method comprobar_vida(adversario){
    	return adversario.vida() <= 0
    }
    
    method eliminar_adversario(adversario){		//Metodo para remover al adversario del tablero, de su almacenamiento y su evento tick
    	if(self.comprobar_vida(adversario)){
    		if(adversario.tipo() == "jefe"){		//Si es el jefe se cierra el juego
    			game.removeVisual(adversario)
    			Oleada.cantidad_jefes().remove(adversario)
    			if(Oleada.comprobar_enemigos()){Oleada.avanzar_oleadas()}}
    			
    		else{
    			game.removeVisual(adversario)
    			Oleada.cantidad_enemigos().remove(adversario)	//Se lo remueve de la coleccion donde se almacena
    			game.removeTickEvent(adversario.id_tick())		//Se remueve su tick
    			if(Oleada.comprobar_enemigos()){Oleada.avanzar_oleadas()}}
    	 }
    }   
    
}

object menu{		//Creacion de un menu donde se ve la oleada, la vida y estamina del heroe
	var property position = game.at(1,13)
	const property color_blanco = "FFFFFF"
	var property oleada = 1
	var property tipo = "menu"
	
	method sumar_oleada(){
		oleada += 1
	}
	method text() = "       " + "Oleada " + oleada.toString() + "  " + "Vida: " + heroe.vida().toString() + "  " + "Estamina: " + heroe.estamina().toString()
	
	method textColor() = self.color_blanco()
}


