class Provincia {
	const property nombre
	const property poblacion = 10000000
	var property ciudades = []
	
	method tieneCiudad(ciudad){
		return ciudades.contains(ciudad)
	}
}

class Ciudad {
	const property nombre
	const property provincia
}

class Certificacion {
	var property puntos = 10
	var property esProducto = true
}

class Vendedor {
	var property certificaciones = []
	
	method esVersatil(){
		return certificaciones.size() >= 3 and self.tieneUnaCertProducto() and  self.tieneUnaCertNoProducto()
	}
	
	method tieneUnaCertProducto(){
		return certificaciones.any{ cert => cert.esProducto()}
	}
	
	method tieneUnaCertNoProducto(){
		return certificaciones.any{ cert => !cert.esProducto()}
	}
	
	method esFirme(){
		return certificaciones.sum{ cert => cert.puntos()} >= 30
	}
	
	method puntajeTotal(){
		return certificaciones.sum{ cert => cert.puntos()}
	}
	
	method addCertificacion(certificacion){
		certificaciones.add(certificacion)
	}
	
	method tiene3CertProductos(){
		return certificaciones.filter{ cert => cert.esProducto()}.size() >= 3
	}
	
}

class Fijo inherits Vendedor {
	var property viveEn //ciudad
	const property esPersonaFisica = true	
	
	
	method puedeTrabajarEn(ciudad){
		return ciudad == viveEn
	}
	
	method esInfluyente(){
		return false
	}
} 

class Viajante inherits Vendedor {
	var property habilitadoEn = [] //provincias
	const property esPersonaFisica = true	
	
	
	method puedeTrabajarEn(ciudad){
		return habilitadoEn.any{ prov => prov.tieneCiudad(ciudad)}
	}
	
	method esInfluyente(){
		return habilitadoEn.sum{ prov => prov.poblacion()} >= 10000000
	}
}

class Comercio inherits Vendedor{
	var property tieneSucursalEn = [] //ciudades
	const property esPersonaFisica = false	
	
	
	method puedeTrabajarEn(ciudad){
		return tieneSucursalEn.contains(ciudad)
	}
	
	// hacer esInfluyente
	method esInfluyente(){
		return tieneSucursalEn.size() >= 5 or self.alMenos3Provincias()
	}
	
	method alMenos3Provincias(){
		return self.provincias().asSet().size() >= 3 
	}
	
	method provincias(){
		return tieneSucursalEn.map{ ciudad => ciudad.provincia()}
	}
	

}

class CentroDeDistribucion {
	var property vendedores = #{}
	var property ciudadDelCentro = ""
	
	method agregarVendedor(vendedor){
		if (!vendedores.any(vendedor)){
			vendedores.add(vendedor)
		}else{
			throw new Exception(message = "El vendedor ya se encuentra en este centro")
		}
	}
	
	method vendedorEstrella(){
		return vendedores.max{ vendedor => vendedor.puntajeTotal()}
	}
	
	method puedeCubrir(ciudad){
		return vendedores.any{ vendedor => vendedor.puedeTrabajarEn(ciudad)}
	}
	
	method vendedoresGenericos(){
		return vendedores.filter{ vendedor => vendedor.tieneUnaCertNoProductos()}
	}
	
	method esRobusto(){
		return vendedores.filter{ vendedor => vendedor.esFirme()}.size() >= 3
	}
	
	method repartirCertificacion(certificacion){
		vendedores.forEach{ vendedor => vendedor.addCertificacion(certificacion)}
	}
	
	method afinidad(vendedor){
		return vendedor.tieneAfinidad(ciudadDelCentro)
	}
	
	// ciudad = la plata
}

object clienteInseguro {
	method puedeSerAtendido(vendedor){
		return vendedor.esVersatil() and vendedor.esFirme()
	}
	
}

object clienteDetallista {
	method puedeSerAtendido(vendedor){
		return vendedor.tiene3CertProductos()
	}
}

object clienteHumanista {
	method puedeSerAtendido(vendedor){
		return vendedor.esPersonaFisica()
	}
}
