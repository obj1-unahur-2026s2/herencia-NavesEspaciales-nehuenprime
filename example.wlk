class Nave {
  var velocidad = 0
  var direccion = 0
  var combustible = 0

  method cargarCombustible(cuanto) {
    combustible += cuanto
  }
  
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }

  method escapar()
  method avisar()

  method estaTranquila() {
    return combustible >= 4000
    && velocidad <= 12000
  }

  method descargarCombustible(cuanto) {
    combustible = (combustible - cuanto).max(0)
  }

  method acelerar(cuanto) {
    velocidad = (velocidad + cuanto).min(100000)
  }
  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }
  
  method desacelerar(cuanto) {
    velocidad = (velocidad - cuanto).max(0)
  }
  method irHaciaElSol() {
    direccion = 10
  }
  method escaparDelSol() {
    direccion = -10
  }

  method ponerseParaleloAlSol() {
    direccion = 0
  }

  method acercarseUnPocoAlSol() {
    direccion = (direccion + 1).min(10)
  }

  method alejarseUnPocoDelSol() {
    direccion = (direccion - 1).max(-10)
  }

  method estaDeRelajo() {
    return self.estaTranquila() && self.tienePocaActividad()
  }

  method tienePocaActividad()

}

class Baliza inherits Nave {
  var color = "azul"
  var cambioDeColor = false
  method cambiarColorDeBaliza(colorNuevo) {
    color = colorNuevo
    if(colorNuevo!=color) {cambioDeColor=true}
  }
  override method prepararViaje() {
    super()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method estaTranquila() {
    return super() && color != "rojo"
  }
  override method escapar() {
    self.irHaciaElSol()
  }
  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }

  override method tienePocaActividad() = !cambioDeColor
}

class Pasajeros inherits Nave {
  const pasajeros
  var comida = 0
  var bebida = 0
  var comidaServida = 0

  method cargarComida(cuanto) {
    comida = comida + cuanto
  }

  method descargarComida(cuanto) {
    comida = (comida-cuanto).max(0)
    comidaServida = comidaServida + cuanto
  }

  method cargarBebida(cuanto) {
    bebida = bebida + cuanto
  }

  method descargarBebida(cuanto) {
    bebida = (bebida - cuanto).max(0)
  }

  override method prepararViaje() {
    super()
    self.cargarComida(pasajeros*4)
    self.cargarBebida(pasajeros*6)
    self.acercarseUnPocoAlSol()
  }
  override method escapar() {
    velocidad = velocidad * 2
  }
  override method avisar() {
    self.descargarBebida(pasajeros*2)
    self.descargarComida(pasajeros)
  }
  override method tienePocaActividad() = comidaServida < 50
}

class Combate inherits Nave {
  var estaVisible = true
  var misilesDesplegados = false
  const mensajes = []
  method ponerseVisible() {estaVisible=true}
  method ponerseInvisible() {estaVisible=false}
  method desplegarMisiles() {misilesDesplegados=true}
  method replegarMisiles() {misilesDesplegados=false}
  method misilesDesplegados() = misilesDesplegados
  method emitirMensaje(mensaje) {
    mensajes.add(mensaje)
  }
  method mensajesEmitidos() = mensajes
  method primerMensajeEmitido() = mensajes.first()
  method ultimoMensajeEmitido() = mensajes.last()
  method esEscueta() = mensajes.all({m=>m.size()<=30})
  method emitioMensaje(mensaje) {
    return mensajes.contains(mensaje)
  }
  override method prepararViaje() {
    super()
    self.acelerar(15000)
    self.ponerseVisible()
    self.replegarMisiles()
    self.emitioMensaje("Saliendo en misión")
  }
  override method estaTranquila() {
    return super() && !misilesDesplegados
  }
  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar() {
    self.emitirMensaje("Amenaza recibida")
  }
  override method tienePocaActividad() = true
}

class Hospital inherits Pasajeros {
  var quirofanosPreparados = false
  method prepararQuirofanos() {quirofanosPreparados=true}
  method desprepararQuirofanos() {quirofanosPreparados=false}
  override method estaTranquila() {
    return super() && !quirofanosPreparados
  }
  override method recibirAmenaza() {
    super()
    self.prepararQuirofanos()
  }
}

class Sigilosa inherits Combate {
  override method estaTranquila() {
    return super() && estaVisible
  }
  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}