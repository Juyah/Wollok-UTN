// TODO: definir la lógica para Olivia
object olivia {
	var masajesRecibidos = 0
	var property gradoDeConcentracion = 4
	method recibirMasajes(){
		masajesRecibidos++
		if(masajesRecibidos < 3)
			gradoDeConcentracion += 2
		else
			gradoDeConcentracion += 5
	}
	method darseUnBanioDeVapor(duracionBanioVapor){
		gradoDeConcentracion += duracionBanioVapor / 5
	}
	method esFeliz(){
		return gradoDeConcentracion >= 7
	}
	method discutir(){
		gradoDeConcentracion = gradoDeConcentracion.min(5)
	}
}

// TODO: definir la lógica para Adriano
object adriano {
	var property nivelDeContractura = 5
	var property frescoParaProgramar = true
	method recibirMasajes(){
		nivelDeContractura = (nivelDeContractura - 2).max(0)
	}
	method darseUnBanioDeVapor(duracionBanioVapor){
		frescoParaProgramar = true
	}
	method comerseUnBigMac(){
		frescoParaProgramar = true
	}
	method codear(){
		if(frescoParaProgramar)
			nivelDeContractura += 1
		else
			nivelDeContractura += 3
		frescoParaProgramar = false
	}
	method trabajarUnDia(){
		self.codear()
		self.comerseUnBigMac()
		self.codear()
	}
}

