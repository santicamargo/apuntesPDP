// TP WOLLOK - PARTE 1, PARTE 2 y PARTE 3

object mundo{
var property fuerzaOscura = 5

method eclipse(){
		fuerzaOscura = fuerzaOscura * 2
    }
}

class Guerrero{

	var property hechizoPreferido
	var property artefactos = []
	var property valorBaseLucha = 1
	var property oro
	var capacidadMaxima

	constructor(_hechizo, _oro, _capacidad){
	hechizoPreferido = _hechizo 
	oro = _oro 
	capacidadMaxima = _capacidad
	}

	method nivelDeHechiceria(){
		return (3 * hechizoPreferido.poder() + mundo.fuerzaOscura())  	 
	}

	method esPoderoso(){
		return hechizoPreferido.esPoderoso()
	}

	method pesoActual(){
		return artefactos.sum({artef => artef.pesoTotal()})
	}

	method agregarArtefacto(_objeto){
		
		var pesoActualizado = self.pesoActual() + _objeto.pesoTotal()
		
		if (pesoActualizado < capacidadMaxima){
		artefactos.add(_objeto)
		_objeto.duenio(self)
		}
		else{
			self.error("No puedo caminar, desprenda artefactos.")
		}
	}

	method eliminarArtefacto(_objeto){
		artefactos.remove(_objeto)
	}

	method eliminarTodosLosArtefactos(){
		 artefactos.clear()
	}

	method nivelDeLucha(){
		return valorBaseLucha + artefactos.sum({artef => artef.lucha()})
	}

	method esMayor(){
		return self.nivelDeLucha() > self.nivelDeHechiceria()
	}
	
	method mejorPertenencia(){
        return self.artefactos().filter{elem=>elem!=espejoFantastico}.map{e=>e.lucha()}.max()
    }

	method comprarArtefacto(artefacto, comerciante){
		
		var comision = comerciante.agregarComision(artefacto)
		
		if (oro >= artefacto.valor() + comision){	
		self.agregarArtefacto(artefacto)
		oro = oro - (artefacto.valor() + comision)
		}
		else
			self.error("Oro insuficiente")
	}

	method comprarHechizo(hechizo, comerciante){
		
		var comision = comerciante.agregarComision(hechizo)
		
		var costo = hechizo.valor() + comision - (hechizoPreferido.valor()/2)
		if (oro >= costo){
			hechizoPreferido=hechizo
			oro = oro - 0.max(costo)
		}
		else
			self.error("Oro insuficiente")
	    }
    
	method estaCargado(){
		return artefactos.size() >= 5
	}	
	
	method cumplirObjetivo(){
		oro = oro + 10 
	}
	
	method cantidadDeArtefactos(){
		return artefactos.size()
	}
}
/* 
-CONSOLA-

var comercianteJuan = new Comerciante(registrado)
var comercianteTomi = new Comerciante(new Independiente(15))
*/
class Comerciante{
	var property categoria// apunta a un objeto
	
	constructor (_categoria){
		categoria = _categoria		
	}
	


	method recategorizacion(){
		self.categoria(categoria.cambioCategoria())
	}

	method agregarComision(artefacto){
		return (categoria.importe(artefacto))
	}
}

class Independiente{
	var comisionPropia
	
	constructor(_comision){
		comisionPropia = _comision
	}

	
	method cambioCategoria(){
		self.duplicarComision()
		
		if (comisionPropia > 21){
			return registrado
		}
		else{
			return self
		}
	}
	
	method duplicarComision(){
		comisionPropia = comisionPropia * 2
	}
	
	method importe(artefacto){
		return artefacto.valor() * comisionPropia / 100
	}
}

object registrado{
	
	method cambioCategoria(){
		return impuestoALasGanancias
	}
	
	method importe(artefacto){
		return artefacto.valor() * 0.21
	}
}

object impuestoALasGanancias{
	
	var property mni = 50
	
	method cambioCategoria(){
		return self
	}
	method importe(artefacto){
		if (artefacto.valor() > mni){
			return (artefacto.valor() - mni) * 0.35
		}
		else{
			return 0
		}
	}
	method cambiarMni(valor){
		return self.mni(valor)
	}
}

class Npc inherits Guerrero{
	var property nivelDePersonaje
	var  multiplicadorDificultad
	
	//CONSULTAR SI ESTO ESTA BIEN O SE UTILIZA DIFERENTES CLASES
	
	constructor(_hechizo,_oro, _capacidad,_nivelDePersonaje) = super (_hechizo,_oro, _capacidad){
		
		nivelDePersonaje = _nivelDePersonaje
		if (nivelDePersonaje == "facil")    multiplicadorDificultad = 1
		if (nivelDePersonaje == "moderado") multiplicadorDificultad = 2
		if (nivelDePersonaje == "dificil")  multiplicadorDificultad = 4
	}
	
	override method nivelDeLucha(){
		return ( valorBaseLucha + artefactos.sum({artef => artef.lucha()}) * multiplicadorDificultad )
	}
	method cambiar(_nivelDePersonaje){
		nivelDePersonaje = _nivelDePersonaje
		
	}
}

object hechizoBasico{
	
	method poder(){
		return 10
	}
	
	method valor(){
		return 10
	}
	
	method esPoderoso(){
		return false
	}
}

class Logos{
	
	var property nombre
	var property multiplo = 1
	
	constructor(_nombre){
		nombre = _nombre
	}
	
	method poder(){
		return nombre.size() * multiplo
	}		
	
	method valor(){
		return self.poder()
	}

	method esPoderoso(){     
		return self.poder()>15 
	}
}


class HechizoComercial inherits Logos{
	var property multiplicador = 2
	var property porcentaje = 20
	var property valorComercial = (multiplicador * porcentaje / 100)
	
	override method poder (){
		return nombre.size() * valorComercial
	}
}

class Artefactos{
	var property duenio
	var property peso
	var property dias
	
	constructor(_peso, _fecha){
		peso = _peso 
		dias = _fecha
	}
	
	method pesoBasico(){
		if (dias <=0)
		return peso
		else
		return (peso - ((self.dias()*0.0001).max(1))).max(0)
	}
	
	method pesoTotal(){
		return self.pesoBasico()
	}
}

object espejoFantastico inherits Artefactos(25,3){

	method lucha(){
	if
		(duenio.artefactos() == [self])
		return 0
	
	else 
		return duenio.mejorPertenencia()
	}
	
	method valor(){
		return 90
	}
}

class Arma inherits Artefactos{
	
	method valor(){
		return 5 * self.pesoBasico()
	}
	
	method lucha (){
		return 3
	}
}

class CollarDivino inherits Artefactos{

	var property perlas = 5

	override method pesoTotal(){
		return ( self.pesoBasico()  + 0.5 * perlas )
	}

	method valor(){
		return 2 * perlas
	}

	method lucha(){
		return perlas
	}
}

class Mascara inherits Artefactos{
	var property oscuridad = 1
	var property minimo = 4
	
   
    
    

	override method pesoTotal(){
		var auxiliar = (self.lucha() - 3)
		
		if (oscuridad == 0){
			return (self.pesoBasico())	
		}
		else{
			
			if (auxiliar > 0){
				return (self.pesoBasico() + auxiliar)
			}
			else{
				return (self.pesoBasico())
			}
		}
	}
	
	method lucha (){
		return ((mundo.fuerzaOscura())/2 * oscuridad).max(minimo)  
	}
	
	method valor(){
		return (10 * oscuridad) 
	}
}

class Armadura inherits Artefactos{
	var property refuerzo = ninguno
	var property base = 2
	
	method cambiarRefuerzo(_refuerzo){
		refuerzo = (_refuerzo)
		_refuerzo.apoderado(duenio)
		_refuerzo.refuerzoDe(self)
	}
	
	override method pesoTotal(){
		return self.pesoBasico() + refuerzo.pesoRefuerzo()
	}
	
	method lucha(){
		return base + refuerzo.aportar()
	}
	method valor(){
		return refuerzo.pesoRefuerzo()
	}
}

class Refuerzos{
	var property apoderado 
    var property refuerzoDe 
    
    method pesoRefuerzo(){
    	return 0
    }
    
}

class CotaDeMalla inherits Refuerzos{
    var property numero
	
	constructor (num) {
		numero = num
	}
	
	method aportar(){
		return numero
	}
	
	method valor(){
		return self.aportar()/2
	}
	
	override method pesoRefuerzo(){
		return 1
	}
	
}

class Bendicion inherits Refuerzos{
	
	method aportar(){
		return apoderado.nivelDeHechiceria()
	}
	method valor(){
		return refuerzoDe.base()
	}
}

class HechizoArmadura inherits Refuerzos{

	var property hechizoSeleccionado

	constructor(_hechizo){
		hechizoSeleccionado = _hechizo
	}
	method aportar(){
		return hechizoSeleccionado.poder()
	}
	
	method valor(){
		return refuerzoDe.base() + hechizoSeleccionado.valor()
	}
	
	override method pesoRefuerzo(){
		if ( (self.aportar()).even() ){
			return 2
		}
		else{
			return 1
		}
	}
}

object ninguno inherits Refuerzos{

	method aportar(){
		return 0
	}
	method valor(){
		return 2
	}
}

class LibroDeHechizos{
	var property duenio 
	var property hechizos = new List()
	
	constructor (_hechizos) {
 		hechizos.add(_hechizos)
 	}

	method esPoderoso(){
		return hechizos.esPoderoso()
	}

	method poder(){
		var hechizosPoderosos = new List()
		hechizosPoderosos = hechizos.filter({hechizo => hechizo.esPoderoso()})
		return hechizosPoderosos.sum({hechizo => hechizo.poder()})
	}

	method agregarHechizo (_hechizo){
		hechizos.add(_hechizo)
	}

	method eliminarHechizo (_hechizo){
		hechizos.remove(_hechizo)
	}

	method valor(){
		return hechizos.size()*10 + self.poder()
	}
}