import wollok.game.*
import objaa.*
import enemigos.*
import oleadas.*

const personajes = game.allVisuals()

class Personajes{
    var property vida = 100
    var property dano = 200
    var property tipo
    
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
    		if(adversario.tipo() == "Jefe"){
    			game.stop()}
    		game.removeVisual(adversario)
    		Oleada.cantidad_enemigos().forEach{enemigo => if(enemigo == adversario){indice = contador} ; contador += 1}
    		Oleada.cantidad_enemigos().remove(adversario)
    		game.removeTickEvent(adversario.numero())
    		if(Oleada.comprobar_enemigos()){Oleada.avanzar_oleadas()}
    	 }
    }   
    
}

object menu{
	var property position = game.at(1,13)
	const property blanco = "FFFFFF"
	var property nivel = 1
	var property tipo = "menu"
	
	method sumar_oleada(){
		nivel += 1
	}
	method text() = "       " + "Oleada " + nivel + "  " + "Vida: " + heroe.vida()
	
	method textColor() = self.blanco()
}



