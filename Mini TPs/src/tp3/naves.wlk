class Nave{
	
	var property velocidad = 0
	
	method propulsar(){
		velocidad += 20000
	}
	
	method estaEnPeligro() = velocidad > self.velocidadMaxima()
	
	method enemigoEncontrado(){
		self.recibirAmenaza()
		self.propulsar()
	}
	
	method velocidadMaxima()
	
	method recibirAmenaza()
	
}




class NaveDeCarga inherits Nave{
	
	var property carga = 0

	method sobrecargada() = carga > 100

	method excedidaDeVelocidad() = velocidad > self.velocidadMaxima()

	override method recibirAmenaza() {
		carga = 0
	}
	
	override method velocidadMaxima() = if(!self.sobrecargada()) 100000 else 80000

}

class NaveDePasajeros inherits Nave{
	
	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	override method velocidadMaxima() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	override method recibirAmenaza() {
		alarma = true
	}
	
	override method estaEnPeligro() = super() || alarma

}

class NaveDeCargaDeResiudosRadioactivos inherits NaveDeCarga{
	
	override method recibirAmenaza(){
		velocidad = 0
	}
	
	override method velocidadMaxima() = super() * 0.75
	
} 

















































