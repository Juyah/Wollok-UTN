/*
* Nombre: Yarbuh, Juan Ignacio
* Legajo: 169077-2
*/

///////////////////////////////////// ACADEMIA /////////////////////////////////////
class AcademiaDeCocina{
	var estudiantesDeLaAcademia
	var recetasDeLaAcademia
	
	method entrenarEstudiantes(){ // Requisito 5
		estudiantesDeLaAcademia.forEach{unEstudiante => unEstudiante.entrenar(recetasDeLaAcademia)}
	}
	
}

///////////////////////////////////// COCINERO /////////////////////////////////////
class Cocinero{
	var comidasQuePreparo
	var nivelDeAprendizajeActual = principiante
	
	method experienciaQueAdquirio() = comidasQuePreparo.sum{unaComida => unaComida.experienciaQueAporta()} // Requisito 1
	
	method superoNivelDeAprendizaje(tipoDeAprendizaje) = tipoDeAprendizaje.puedeSuperarlo(self) // Requisito 2
	
	method preparoMasDeComidasDificiles(cantidadDeComidasDificiles) = comidasQuePreparo.count{unaComida => unaComida.fueDificilDePreparar()} > cantidadDeComidasDificiles
	
	method prepararComida(unaReceta){ // Requisito 3
		if(not self.puedePreparar(unaReceta))
			throw new NivelInsuficienteException(message = "El cocinero no puede preparar esta receta")
		
		comidasQuePreparo.add( new Comida(calidadDeComida = self.calidadPreparacion(unaReceta) , receta = unaReceta) )
		self.subirDeNivelDeAprendizaje()
	}
	
	method calidadPreparacion(unaReceta) = nivelDeAprendizajeActual.calidadDePreparacion(unaReceta, self)
	
	method subirDeNivelDeAprendizaje(){
		const nivelSiguiente = nivelDeAprendizajeActual.siguienteNivel()
		
		if(not self.superoNivelDeAprendizaje(nivelDeAprendizajeActual))
			throw new NoPuedeSubirDeNivelException(message = "El cocinero no cuenta lo requerido para el siguiente nivel")
		
		nivelDeAprendizajeActual = nivelSiguiente
	}
	
	method perfeccionoReceta(unaReceta) = self.experienciaDeRecetasSimilares(unaReceta) > unaReceta.experienciaBase() * 3
	
	method preparoRecetaSimilar(unaReceta) = comidasQuePreparo.any{unaComida => unaReceta.esSimilar(unaComida.receta())}
	
	method cantidadDeRecetasSimilares(unaReceta) = self.recetasSimilares(unaReceta).size()
	
	method experienciaDeRecetasSimilares(unaReceta) = self.recetasSimilares(unaReceta).sum{unaComida => unaComida.experienciaQueAporta()} //Se supone la experiencia tomando en cuenta la calidad de los platos previos. Sin la calidad seria unaComida.experienciaNormal()
	
	method recetasSimilares(unaReceta) = comidasQuePreparo.filter{unaComida => unaReceta.esSimilar(unaComida.receta())}
	
	method elegirMejorReceta(recetas) = recetas.filter{unaReceta => self.puedePreparar(unaReceta)}.max{unaReceta => unaReceta.experienciaBase()}  //self.experienciaDeReceta(unaReceta)	En caso de que se elegia por experiencia total. Del Requisito 5
	
	method puedePreparar(unaReceta) = nivelDeAprendizajeActual.puedePreparar(unaReceta, self)
	
	method entrenar(recetas){
		const mejorReceta = self.elegirMejorReceta(recetas)
		self.prepararComida(mejorReceta)
	}
	
	// method experienciaDeReceta(unaReceta) = unaReceta.experienciaQueAportaria(self.calidadPreparacion(unaReceta))	En caso de que se necesitaba la experiencia final. Del Requisito 5
}
///////////////////////////////////// TIPO DE APRENDIZAJE /////////////////////////////////////
object principiante{
	
	method puedeSuperarlo(unCocinero) = unCocinero.experienciaQueAdquirio() > 100
	
	method puedePreparar(unaReceta, unCocinero) = not unaReceta.esDificil()
	
	method siguienteNivel() = experimentado
	
	method calidadDePreparacion(unaReceta, unCocinero) = if( unaReceta.cantidadDeIngredientes() < 4 ) normal else pobre
}

object experimentado{

	method puedeSuperarlo(unCocinero) = unCocinero.preparoMasDeComidasDificiles(5)
	
	method puedePreparar(unaReceta, unCocinero) = unCocinero.preparoRecetaSimilar(unaReceta)
	
	method siguienteNivel() = chef
	
	method calidadDePreparacion(unaReceta, unCocinero) = if( unCocinero.perfeccionoReceta(unaReceta) ) new Superior( experienciaPlus = unCocinero.cantidadDeRecetasSimilares(unaReceta) / 10 ) else normal
}

object chef{
	
	method puedeSuperarlo(unCocinero) = false
	
	method puedePreparar(unaReceta, unCocinero) = true
	
	method siguienteNivel() = self
	
	method calidadDePreparacion(unaReceta, unCocinero) = experimentado.calidadDePreparacion(unaReceta, unCocinero)
}



///////////////////////////////////// RECETA /////////////////////////////////////
class Receta{
	const property ingredientes //= #{}
	const property nivelDeDificultadDePreparacion
		
	// method experienciaQueAportaria(calidadDeComida) =  calidadDeComida.experienciaQueAporta(self)  Para suposiciones del Requisito 4 y 5
	
	method experienciaBase() = self.cantidadDeIngredientes() * nivelDeDificultadDePreparacion
	
	method esDificil() = nivelDeDificultadDePreparacion > 5 || ingredientes.size() > 10
	
	method cantidadDeIngredientes() = ingredientes.size()
	
	method esSimilar(otraReceta) = ( ingredientes == otraReceta.ingredientes() ) || ( nivelDeDificultadDePreparacion - otraReceta.nivelDeDificultadDePreparacion() <= 1 )
}

class Gourmet inherits Receta{ // Requisito 4
	override method experienciaBase() = super() * 2 //Se supone que el efecto de la calidad de la comida no se toma en cuenta, en el otro caso seria override de experienciaQueAporta(unaComida)
	
	override method esDificil() = true
}
///////////////////////////////////// COMIDA /////////////////////////////////////
class Comida{
	const property receta
	const calidadDeComida
	
	method experienciaQueAporta() =  calidadDeComida.experienciaQueAporta(self)
	
	method experienciaNormal() = receta.experienciaBase()
	
	method fueDificilDePreparar() = receta.esDificil()
}
///////////////////////////////////// CALIDAD DE COMIDA /////////////////////////////////////
object pobre{
	var property experienciaMaxima = 4
	
	method experienciaQueAporta(unaComida) = experienciaMaxima.min(unaComida.experienciaNormal())
}

object normal{
	method experienciaQueAporta(unaComida) = unaComida.experienciaNormal()
}

class Superior{
	var property experienciaPlus
	
	method experienciaQueAporta(unaComida) = unaComida.experienciaNormal() + experienciaPlus
}


///////////////////////////////////// MANEJO DE ERRORES /////////////////////////////////////

class NivelInsuficienteException inherits DomainException{}

class NoPuedeSubirDeNivelException inherits DomainException{}



///////////////////////////////////// INFORMACIÓN DE ENTRADAS Y SEMI-TESTS /////////////////////////////////////

// Requisito 1 -> Metodo perteneciente a la clase Cocinero, method experienciaQueAdquirio()
const recetaTest = new Receta(nivelDeDificultadDePreparacion = 2, ingredientes = ["agua","azucar","sal"])
const cocinero1 = new Cocinero(comidasQuePreparo = [new Comida(receta = recetaTest, calidadDeComida = normal), new Comida(receta = recetaTest, calidadDeComida = new Superior(experienciaPlus = 10))])
const cocinero2 = new Cocinero(comidasQuePreparo = [new Comida(receta = recetaTest, calidadDeComida = normal), new Comida(receta = recetaTest, calidadDeComida = new Superior(experienciaPlus = 10)), new Comida(receta = recetaTest, calidadDeComida = pobre), new Comida(receta = recetaTest, calidadDeComida = pobre)])

/*
 * cocinero1.experienciaQueAdquirio()	-> 22
 * cocinero2.experienciaQueAdquirio()	-> 30
 * pobre.experienciaMaxima(7)			-> <EFECTO>
 * cocinero2.experienciaQueAdquirio()	-> 34
 */
 
// Requisito 2 -> Metodo perteneciente a la clase Cocinero, method superoNivelDeAprendizaje(tipoDeAprendizaje)
const recetaGorumet = new Gourmet(ingredientes = ["agua","azucar","sal"], nivelDeDificultadDePreparacion = 1)
const recetaDificil = new Receta(ingredientes = ["agua","azucar","sal"], nivelDeDificultadDePreparacion = 8)
const cocineroSuperaPrincipiante = new Cocinero(comidasQuePreparo = [new Comida(receta = recetaTest, calidadDeComida = normal), new Comida(receta = recetaTest, calidadDeComida = new Superior(experienciaPlus = 40)), new Comida(receta = recetaTest, calidadDeComida = new Superior(experienciaPlus = 50))])
const cocineroNoSuperaPrincipiante = new Cocinero(comidasQuePreparo = [new Comida(receta = recetaTest, calidadDeComida = normal), new Comida(receta = recetaTest, calidadDeComida = new Superior(experienciaPlus = 10))])
const cocineroSuperaExperimentado = new Cocinero(comidasQuePreparo = [new Comida(receta = recetaDificil, calidadDeComida = normal) ,new Comida(receta = recetaGorumet, calidadDeComida = normal), new Comida(receta = recetaGorumet, calidadDeComida = normal), new Comida(receta = recetaGorumet, calidadDeComida = normal), new Comida(receta = recetaGorumet, calidadDeComida = normal), new Comida(receta = recetaGorumet, calidadDeComida = normal)])
const cocineroNoSuperaExperimentado = new Cocinero(comidasQuePreparo = [new Comida(receta = recetaTest, calidadDeComida = normal), new Comida(receta = recetaTest, calidadDeComida = new Superior(experienciaPlus = 10)), new Comida(receta = recetaTest, calidadDeComida = pobre), new Comida(receta = recetaTest, calidadDeComida = pobre)])

/*
 * Devuelven los bool correspondientes <COCINERO>.superoNivelDeAprendizaje(<LoQueSeTesteaDeElCocinero>)
 */

// Requisito 3 -> Metodo perteneciente a la clase Cocinero, method prepararComida(unaReceta)

/*
 * Complejo de testear solo en consola, corresponderia hacer los tests formales
 */

// Requisito 4 -> Metodo perteneciente a la clase Gourmet, las entradas son los 2 metodos con override los cuales son override method experienciaBase() y override method esDificil()

const gourmetDificil = new Gourmet(ingredientes = ["agua"], nivelDeDificultadDePreparacion = 1)
const recetaNoDificil = new Receta(ingredientes = ["agua"], nivelDeDificultadDePreparacion = 1)
const gourmetDoble = new Gourmet(ingredientes = ["aceite", "agua"], nivelDeDificultadDePreparacion = 12 )
const receta = new Receta(ingredientes = ["aceite", "agua"], nivelDeDificultadDePreparacion = 12 )

/*
 * gourmetDificil.esDificil()		-> true
 * recetaNoDificil.esDificil()		-> false
 * gourmetDoble.experienciaBase()	-> 48
 * receta.experienciaBase()			-> 24
 */

// Requisito 5 -> Metodo perteneciente a la clase AcademiaDeCocina, method entrenarEstudiantes()

/*
 * Complejo de testear solo en consola, corresponderia hacer los tests formales
 */