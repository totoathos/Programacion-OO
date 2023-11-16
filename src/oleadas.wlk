import wollok.game.*
import class_personajes.*
import instancias.*
import enemigos.*

class Oleadas{
	var property cantidad_enemigos = []
	var property cantidad_jefes = []
	var property cantidad_puas= []
	var generador_enemigos = 5.randomUpTo(7).truncate(0)
	var dificultad = 1
	var property oleada = 1
	
	
	method comprobar_nivel(){	//Metodo que comprueba el nivel de la oleada para aumentar su dificultad
		if(oleada<=4){
			dificultad = 1
			return "Principiante"
		}
		
		
		if(5<oleada and oleada<=10){
			dificultad = 1.25
			return "intermedio"
		}
		
		
		return " " 
	}
	
	method comprobar_enemigos(){		//Comprueba si la coleccion donde se almacenan enemigos esta vacia
		return cantidad_enemigos.isEmpty()
	}
	
	method avanzar_oleadas(){	//Metodo que permite el avance de oleadas y la recuperacion de vida y estamina con el pasar de las mismas
			
			if(not(oleada == 10)){
				oleada += 1
				Menu.sumar_oleada()
				if(heroe.vida() < 90){heroe.vida(heroe.vida() + 20)}
				heroe.aumentar_estamina()
				self.crear_enemigos()		
			}
			if((self.comprobar_enemigos()) and cantidad_jefes.isEmpty()){
				oleada += 1
				Menu.sumar_oleada()
				if(heroe.vida() < 90){heroe.vida(heroe.vida() + 20)}
				heroe.aumentar_estamina()
				self.crear_enemigos()
			}
			
		
	}
	
	
	method crear_enemigos(){		//Metodo donde creamos enemigos segun la dificultad
		var contador = 0	//Se usa para realizar ticks propios de cada enemigo 
		(1 .. generador_enemigos).forEach{n => const id_a = contador.toString() + "a"; const id_b = contador.toString() + "b" ; cantidad_enemigos.add(new Enemigos_Larga_Distancia(id_tick = id_a , vida = 75*dificultad,dano = 30*dificultad,tipo="enemigo_largo")); cantidad_enemigos.add(new Enemigo_Corta_Distancia (id_tick = id_b ,vida = 75*dificultad,dano = 30*dificultad,tipo="enemigo_corto")) ; contador += 1}
		cantidad_enemigos.forEach{n => game.addVisual(n)}
		cantidad_enemigos.forEach{n=> game.onTick(1600.randomUpTo(2100), n.id_tick(), {n.seguir(heroe) ; if(n.position()==heroe.position()){n.ataque(heroe)}})}
		
		if(oleada == 10){		//Si se llega a la oleada 10 entonces se crea el jefe
			cantidad_jefes.add(new Jefes(vida=200, dano=50, dificultad=dificultad, tipo= "jefe"))
			}
	
}

}
