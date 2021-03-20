import tp4.usuario.*

// TODO: Definí la lógica acá


class Publicacion{
	const property fechaPublicada
	const property usuarioAutor
	var property tipoPrivacidad
	
	method esVisible(unUsuario, unaFecha) = self.laVeElAutor(unUsuario) || self.cumpleRequisito(unUsuario, unaFecha)
	
	method cumpleRequisito(unUsuario, unaFecha) = unaFecha >= fechaPublicada && tipoPrivacidad.esVisible(usuarioAutor, unUsuario)
	
	method laVeElAutor(unUsuario) = usuarioAutor == unUsuario
}

class Historia inherits Publicacion{
	override method cumpleRequisito(usuario, fecha) = super(usuario, fecha) && fecha - fechaPublicada <= 1
}

object publica{
	method esVisible(usuarioAutor, unUsuario) = true
}

object privada{
	method esVisible(usuarioAutor, unUsuario) = usuarioAutor.tieneContacto(unUsuario)
}

class ListaNegra{
	var contactosRestringidos
	
	method esVisible(usuarioAutor, unUsuario) = privada.esVisible(usuarioAutor, unUsuario) && !contactosRestringidos.contains(unUsuario)
}