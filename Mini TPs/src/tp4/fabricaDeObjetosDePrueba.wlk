import tp4.usuario.*
import tp4.redSocial.*

// Para facilitar la creación de objetos de prueba
object fabrica {
	const property creador = new Usuario(nombre = "Tito")
	
	method fechaPublicacion() = new Date()
	
	method fechaLejanaAPublicacion() = self.fechaPublicacion().plusDays(10)
	method diaSiguienteAPublicacion() = self.fechaPublicacion().plusDays(1)
	
	method configurarContactos(){
		creador.agregarContacto(new Usuario(nombre = "Ana"))
		creador.agregarContacto(new Usuario(nombre = "Fito"))
	}
	
	method desconocido() = new Usuario(nombre = "Anónimo")
	method contactoDelCreador() = self.creador().contactos().anyOne()
	
	method usuariosDePrueba() 
		= #{creador, self.desconocido()} + creador.contactos()
	
	/*
	 * TODO crear y retornar el contenido correspondiente
	 * usando self.creador() como usuario creador del contenido y 
	 * self.fechaPublicacion() como fecha de publicación del mismo
	 */ 
	method crearPublicacionPublica() {
		return new Publicacion(fechaPublicada = self.fechaPublicacion(), usuarioAutor = self.creador(), tipoPrivacidad = publica)
	}
	method crearPublicacionPrivada() {
		return new Publicacion(fechaPublicada = self.fechaPublicacion(), usuarioAutor = self.creador(), tipoPrivacidad = privada)
	}
	method crearHistoriaPublica() {
		return new Historia(fechaPublicada = self.fechaPublicacion(), usuarioAutor = self.creador(), tipoPrivacidad = publica)
	}
	method crearHistoriaPrivada() {
		return new Historia(fechaPublicada = self.fechaPublicacion(), usuarioAutor = self.creador(), tipoPrivacidad = privada)
	}
	method crearPublicacionConListaNegra(usuariosParaListaNegra) {
		return new Publicacion(fechaPublicada = self.fechaPublicacion(), usuarioAutor = self.creador(), tipoPrivacidad = new ListaNegra(contactosRestringidos = usuariosParaListaNegra))
	}
	method crearHistoriaConListaNegra(usuariosParaListaNegra) {
		return new Historia(fechaPublicada = self.fechaPublicacion(), usuarioAutor = self.creador(), tipoPrivacidad = new ListaNegra(contactosRestringidos = usuariosParaListaNegra))
	}
}