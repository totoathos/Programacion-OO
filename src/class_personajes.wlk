import wollok.game.*
import instancias.*
import enemigos.*
import oleadas.*

const personajes = game.allVisuals()

class Personajes{
    var property vida = 100
    var property dano = 200
    var property tipo
    var property direccion_personaje = "der"
    
    method ataque(entidad){
        entidad.vida(entidad.vida() - dano)
        self.eliminar_adversario(entidad)
        
    }
    
    method comprobar_vida(adversario){
    	return adversario.vida() <= 0
    }
    
    method eliminar_adversario(adversario){
    	if(self.comprobar_vida(adversario)){
    		if(adversario.tipo() == "Jefe"){
    			game.stop()}
    		game.removeVisual(adversario)
    		Oleada.cantidad_enemigos().remove(adversario)
    		game.removeTickEvent(adversario.id_tick())
    		if(Oleada.comprobar_enemigos()){Oleada.avanzar_oleadas()}
    	 }
    }   
    
}

object menu{
	var property position = game.at(1,13)
	const property color_blanco = "FFFFFF"
	var property oleada = 1
	var property tipo = "menu"
	
	method sumar_oleada(){
		oleada += 1
	}
	method text() = "       " + "Oleada " + oleada + "  " + "Vida: " + heroe.vida()
	
	method textColor() = self.color_blanco()
}



