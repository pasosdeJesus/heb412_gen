
export default class Heb412Gen__Motor {
  /* 
   * Librería de funciones comunes.
   * Aunque no es un controlador lo dejamos dentro del directorio
   * controllers para aprovechar método de msip para compartir controladores
   * Stimulus de motores.
   *
   * Como su nombre no termina en _controller no será incluido en 
   * controllers/index.js
   *
   * Desde controladores stimulus importelo con
   *
   *  import Heb412Gen__Motor from "../heb412_gen/motor"
   *
   * Use funciones por ejemplo con
   *
   *  Heb412Gen__Motor.ejecutarAlCargarPagina()
   *
   * Para poderlo usar desde Javascript global con window.Heb412Gen__Motor 
   * asegure que en app/javascript/application.js ejecuta:
   *
   * import Heb412Gen__Motor from './controllers/heb412_gen/motor.js'
   * window.Heb412Gen__Motor = Heb412Gen__Motor
   *
   */


  // Llamar cada vez que se cargue una página detectada con turbo:load
  // Tal vez en cache por lo que podría no haberse ejecutado iniciar 
  // nuevamente.
  // Podría ser llamada varias veces consecutivas por lo que debe detectarlo
  // para no ejecutar dos veces lo que no conviene.
  static ejecutarAlCargarPagina() {
    console.log("* Corriendo Heb412Gen__Motor::ejecutarAlCargarPagina()")
  }

}
