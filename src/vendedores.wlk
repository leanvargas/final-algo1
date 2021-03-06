class UserException inherits Exception {}

class Provincia {
	var property poblacion
}

class Ciudad {
	const property provincia
}

class Certificacion {
	const property puntos
	const property esProducto = true
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

	method esCandidato(vendedor){
		return self.esVersatil() and self.tieneAfinidad(vendedor)
	}
		
	method tieneCertificacion(certificacion){
		return certificaciones.contains(certificacion)
	}
	
	method puedeTrabajarEn(ciudad)
	
	method tieneAfinidad(centro){
		return self.puedeTrabajarEn(centro.ciudadDelCentro())
	}
	
}

class Fijo inherits Vendedor {
	var property viveEn //ciudad
	const property esPersonaFisica = true


	override method puedeTrabajarEn(ciudad){
		return ciudad.equals(viveEn)
	}

	method esInfluyente(){
		return false
	}

}

class Viajante inherits Vendedor {
	var property habilitadoEn = #{} //provincias
	const property esPersonaFisica = true


	override method puedeTrabajarEn(ciudad){
		return habilitadoEn.contains(ciudad.provincia())
	}

	method esInfluyente(){
		return habilitadoEn.sum{ prov => prov.poblacion()} >= 10000000
	}

}

class Comercio inherits Vendedor{
	var property tieneSucursalEn = [] //ciudades
	const property esPersonaFisica = false


	override method puedeTrabajarEn(ciudad){
		return tieneSucursalEn.contains(ciudad)
	}

	method esInfluyente(){
		return tieneSucursalEn.size() >= 5 or self.alMenos3Provincias()
	}

	method alMenos3Provincias(){
		return self.provincias().asSet().size() >= 3
	}

	method provincias(){
		return tieneSucursalEn.map{ ciudad => ciudad.provincia()}
	}
	
	method alMenosUnaCiudadNoPuedeCubrir(centro){
		return tieneSucursalEn.any{ ciudad => !centro.puedeCubrir(ciudad)}
	}
	
	override method tieneAfinidad(centro){
		return super(centro) and self.alMenosUnaCiudadNoPuedeCubrir(centro)
	}

}

class CentroDeDistribucion {
	var property vendedores = #{}
	var property ciudadDelCentro

	method agregarVendedor(vendedor){
		if (!vendedores.contains(vendedor)){
			vendedores.add(vendedor)
		}else{
			throw new UserException(message = "El vendedor ya se encuentra en este centro")
		}
	}

	method vendedorEstrella(){
		return vendedores.max{ vendedor => vendedor.puntajeTotal()}
	}

	method puedeCubrir(ciudad){
		return vendedores.any{ vendedor => vendedor.puedeTrabajarEn(ciudad)}
	}

	method vendedoresGenericos(){
		return vendedores.filter{ vendedor => vendedor.tieneUnaCertNoProducto()}
	}

	method esRobusto(){
		return vendedores.filter{ vendedor => vendedor.esFirme()}.size() >= 3
	}

	method repartirCertificacion(certificacion){
		vendedores.forEach{ vendedor => vendedor.addCertificacion(certificacion)}
	}



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

object clientes{
	const clientes = [clienteInseguro, clienteDetallista, clienteHumanista]
	
	method elComercioPuedeAtenderlos(comercio){
		return clientes.all{ cliente => cliente.puedeSerAtendido(comercio)}
	}
}


















