// TODO: Implementar todo lo necesario para cumplir con los requerimientos aquí 
class ProductoUnitario{
	const property descripcion
	const property precio
}

class ProductoPorPeso{
	const property descripcion
	const property precioPorKilo
	var property peso
	
	method precio() = precioPorKilo * peso	
}

object carrito{
	var property productos = []
	
	method agregar(Producto){
		productos.add(Producto)
	}
	method estaVacio() = productos.isEmpty()
	method cantidadDeProductos() = productos.size()
	method totalAAbonar() = productos.sum({unProducto => unProducto.precio()})
	method productoMasCaro() = productos.max({unProducto => unProducto.precio()})
	method detalleDeCompra() = productos.asSet().map({unProducto => unProducto.descripcion()}).sortedBy({unProducto, otroProducto => unProducto < otroProducto })
}