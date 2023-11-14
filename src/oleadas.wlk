import wollok.game.*
import obj.*
import objaa.*
import enemigos.*

class Oleadas{
	var property cantidad_enemigos = []
	var generador_enemigos = 1.randomUpTo(2).truncate(0)
	var dificultad = 1
	var property nivel = 1
	var property cantidad_puas = []
	
	//comprueba el nivel de la oleada para luego aumentar la dificultad automaticamente
	method comprobar_nivel(){
		if(nivel<=4){
			dificultad = 1
			return "Principiante"
		}
		
		
		if(5<=nivel and nivel<=10){
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
			cantidad_puas.clear()
			self.crear_enemigos()
	}
	
	//para crear los enemigos evaluamos la oleada para determinar la dificultad
	method crear_enemigos(){
		var contador = 0
		(1 .. generador_enemigos).forEach{n => const numero_a = contador.toString() + "a"; const numero_b = contador.toString() + "b" ; contador = contador+1; cantidad_enemigos.add(new Enemigos_Larga_Distancia(numero = numero_a , vida = 75*dificultad,dano = 30*dificultad,tipo="enemigo_largo")); cantidad_enemigos.add(new Enemigo_Corta_Distancia(numero= numero_b ,vida = 75*dificultad,dano = 30*dificultad,tipo="enemigo_corto"))}
		cantidad_enemigos.forEach{n=> if((n.tipo()=='enemigo_corto') or n.tipo()=='enemigo_largo'){game.onTick(1600.randomUpTo(2100), n.numero(), {n.seguir(heroe) ; if(n.position()==heroe.position()){n.ataque(heroe)}})}}
		cantidad_enemigos.forEach{n=> if((n.tipo()=='Jefe')){game.onTick(1600.randomUpTo(2100), n.numero(), {if(n.position()==heroe.position()){n.ataque(heroe)}})}}
		
		if(nivel == 5 or nivel == 10){
			cantidad_enemigos.add(new Jefes(vida=200, dano=50, dificultad=dificultad))
			}
	

}
}
