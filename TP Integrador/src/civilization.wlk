//-------------------------------IMPERIO-------------------------------
class Imperio{
	const property ciudades = [] //DONE 2
	var property dinero = 0 //DONE 1

	method estaEndeudado() = dinero < 0	

	method esMasPoderosoQue(unImperio) = self.cantidadCiudadesGrosas() > unImperio.cantidadCiudadesGrosas()
	
	method cantidadCiudadesGrosas() = ciudades.count{unaCiudad => unaCiudad.esGrosa()}

	method seEndeuda(cantidadGastar) = dinero <= cantidadGastar

	method gastar(cantidad){
		dinero -= cantidad
	}
	
	method cobrar(cantidad){
		dinero += cantidad
	}
	
	method evolucionarImperio(){	
		ciudades.forEach{unaCiudad => unaCiudad.evolucionar()}
	}
	
	method ciudadNueva(ciudad){
		ciudades.add(ciudad)
	}
	
	method gastarConstruccion(costeEdificio){
		if(self.seEndeuda(costeEdificio))
			throw new ImperioSeEndeuda(message = "No se puede realizar la construcción, nos endeudariamos")
		self.gastar(costeEdificio)
	}
}



//-------------------------------CIUDAD-------------------------------
class Ciudad{
	const property imperio
	var property habitantes 
	var property edificios
	var property sistemaImpositivo
	var property unidadesMilitares 
	

	method esFeliz() = self.esTranquila() && not imperio.estaEndeudado()
	
	method esTranquila() = self.tranquilidad() > self.disconformidad()
	
	method tranquilidad() = edificios.sum{unEdificio => unEdificio.tranquilidad()}

	method disconformidad() = habitantes / 10000 + unidadesMilitares.min(30)

	method esGrosa() = habitantes > 1000000 || (edificios.size() >= 20 && unidadesMilitares > 10)
	
	method construirEdificio(edificio){
		const costeEdificio = edificio.costoFinal(self, sistemaImpositivo)
		
		imperio.gastarConstruccion(costeEdificio)
		edificio.construir(costeEdificio, habitantes)
		edificios.add(edificio)
	}
	
	method evolucionar(){
		if(self.esFeliz())
			habitantes += habitantes * 0.02
		edificios.forEach{unEdificio => unEdificio.evolucionar(self, sistemaImpositivo)}
	}
	
	method sumarUnidadesMilitares(cantidad){
		unidadesMilitares += cantidad
	}
	
	method gastar(cantidad){
		imperio.gastar(cantidad)
	}
	
	method cobrar(cantidad){
		imperio.cobrar(cantidad)
	}
}
//-------------------------------SISTEMA IMPOSITIVO-------------------------------
object citadino{
	method costoDeConstrucion(edificio, ciudad) = edificio.costoBase() + edificio.costoBase() * 0.05 * ciudad.habitantes() / 25000
}

object incentivoCultural{	
	method costoDeConstrucion(edificio, ciudad) = edificio.costoBase() - edificio.cultura() / 3
}

class Apaciguador{
	const porcentaje	
	
	method costoDeConstrucion(edificio, ciudad) = if(ciudad.esFeliz()) edificio.costoBase() + edificio.costoBase() * porcentaje / 100 else edificio.costoBase() - edificio.tranquilidad()
}



//-------------------------------EDIFICIOS-------------------------------
class Edificio{
	const property costoBase
	
	method costoMantenimiento(ciudad, sistemaImpositivo) = self.costoFinal(ciudad, sistemaImpositivo) * 0.1
	
	method costoFinal(ciudad, sistemaImpositivo) = sistemaImpositivo.costoDeConstrucion(self, ciudad)
	
	method construir(costoEdificio, habitantes){}
	
	method evolucionar(ciudad, sistemaImpositivo){
		ciudad.gastar(self.costoMantenimiento(ciudad, sistemaImpositivo))
	}
}
class Economico inherits Edificio{
	const property dinero
	
	method tranquilidad() = 3
	
	method cultura() = 0
	
	method militares() = 0
	
	override method evolucionar(ciudad, sistemaImpositivo){
		super(ciudad, sistemaImpositivo)
		ciudad.cobrar(dinero)
	}
}
class Cultural inherits Edificio{
	const property cultura

	method tranquilidad() = cultura * 3
	
	method militares() = 0
	
	method dinero() = 0
}
class Militar inherits Edificio{
	const property militares
	
	method tranquilidad() = 0
	
	method dinero() = 0
	
	method cultura() = 0
	
	override method evolucionar(ciudad, sistemaImpositivo){
		super(ciudad, sistemaImpositivo)
		ciudad.sumarUnidadesMilitares(militares)
	}
	
	override method construir(costoEdificio, habitantes){
		if(habitantes < 20000)
			throw new EdificioMilitarConHabitantesInsuficientes(message = "No se puede realizar la construcción, no hay habitantes suficientes para el edificio militar")
	}
}



//-------------------------------ERRORES-------------------------------
class ImperioSeEndeuda inherits DomainException{}
class EdificioMilitarConHabitantesInsuficientes inherits DomainException{}



































