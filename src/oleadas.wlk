import wollok.game.*
import obj.*
import objaa.*
import enemigos.*

class Oleadas{
	var property cantidad_enemigos = []
	var property cantidad_jefes = []
	var generador_enemigos = 5.randomUpTo(6).truncate(0)
	var dificultad = 1
	var nivel = 1
	
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
			Menu.sumar_oleada()
			self.crear_enemigos()
			
		
	}
	
	//para crear los enemigos evaluamos la oleada para determinar la dificultad
	method crear_enemigos(){
		(1 .. generador_enemigos).forEach{n => cantidad_enemigos.add(new Enemigos_Larga_Distancia(vida = 75*dificultad,dano = 30*dificultad,tipo="enemigo_largo")); cantidad_enemigos.add(new Enemigo_Corta_Distancia(vida = 75*dificultad,dano = 30*dificultad,tipo="enemigo_corto"))}
		cantidad_enemigos.forEach{n => game.addVisual(n)}
		cantidad_enemigos.forEach{n => game.onTick(1600.randomUpTo(2100), 'seguir_enemigos', {if(n.tipo() == "enemigo_corto" or n.tipo() == "enemigo_largo"){n.seguir(heroe) ; if(n.position()==heroe.position()){n.ataque(heroe)}}})}
		
		if(nivel == 5 or nivel == 10){
			cantidad_jefes.add(new Jefes(vida=200, dano=50))
			}
	

}

}
