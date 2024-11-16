
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


  // Se ejecuta cada vez que se carga una página que no está en cache
  // y tipicamente después de que se ha cargado la página y los recursos.
  static ejecutarAlCargarDocumentoYRecursos() {
    console.log("* Corriendo Heb412Gen__Motor::ejecutarAlCargarDocumentoYRecursos()")
    if (window.location.href.match(/\/plantillahcm\/ */)) {
      document.addEventListener('change', event => { 
        if (event.target.id = "plantillahcm_vista") {
          Msip__Motor.enviarAjaxDatosRutaYPinta(
            'plantillahcm/pintacampos', 'vista=' + $(this).val(), 
            '#gen_divcampos', '#divcampos'
          )
        }
      })
    }

    // MENUS CONTEXTUALES
    if (document.querySelectorAll("#heb412_mcarc").length > 0) {
      document.querySelector("#heb412_mcarc").style.display = 'none';
      document.querySelector("#heb412_mcdir").style.display = 'none';
    }

    document.querySelectorAll(".heb412_archivo").forEach( (a) => {
      a.addEventListener("contextmenu", (e) => {
        let indice = 0
        if (e.target.classList.contains('heb412_archivo')) {
          indice = e.target.dataset['heb412Indice']
        } else if (e.target.parentElement.classList.contains('heb412_archivo')) {
          indice = e.target.parentElement.dataset['heb412Indice']
        }

        if (indice > 0) {
          window.heb412_mcarc_descarga = document.querySelector(
            '#heb412-enlace-' + indice
          )
        } else {
          window.heb412_mcarc_descarga = null
        }
        document.querySelector("#heb412_mcarc").style.display = "block"
        document.querySelector("#heb412_mcarc").style.left = e.pageX
        document.querySelector("#heb412_mcarc").style.top = e.pageY
        return false;
      })
    })
    if (document.querySelectorAll(".heb412_directorio").length > 0) {

      document.querySelector(".heb412_directorio").
        addEventListener("contextmenu", 
          (e) => {
            if (e.target.getAttribute('href') == null) {
              window.heb412_mcdir_enlace = e.target.parentElement
            } else {
              window.heb412_mcdir_enlace = e.target
            }
            document.querySelector("#heb412_mcdir").style.display = "block"
            document.querySelector("#heb412_mcdir").style.left = e.pageX
            document.querySelector("#heb412_mcdir").style.top = e.pageY

            document.addEventListener("click", (e) => {
              if (e.button == 0) {
                document.querySelector(".heb412_menucontextual").style.display = "none"
              }
            })
          }
        )

      document.addEventListener("mouseleave", e => {
        if (e.target.querySelectorAll(".heb412_menucontextual").length > 0) {

          // NO se requiere y al dejarlo no propaga bien cuando se elije Eliminar
          // $(".heb412_menucontextual").hide("fast");
        }
      })

      document.addEventListener("keydown", e => {
        if (e.keyCode == 27) {
          document.querySelector(".heb412_menucontextual").style.display = "none"
        }
      })

      document.addEventListener("click", e => {
        if (e.target.id == "heb412_mcarc") {
          Msip__Motor.arreglarPuntoMontaje()
          let t = Date.now()
          let d = -1
          if (window.heb412_mcarc_t) {
            d = (t - window.heb412_mcarc_t)/1000
          }
          // NO se permite mas de un envio en 2 segundos 
          if (d == -1 || d > 2) {
            window.heb412_mcarc_t = t
            switch (e.target.id) {
              case "descargar":
                window.heb412_mcarc_descarga.click()
                break
              case "renombrar":
                alert("renombrado archivo!")
                break
              case "eliminar": 
                Heb412Gen__Motor.eliminarArchivo(window.heb412_mcarc_descarga.href)
                break
              case "permisos":
                alert("estableciendo permisos!")
                break
            }
          }
          return false
        } else if (e.target.id == "heb412_mcdir") {
          let t = Date.now()
          let d = -1
          if (window.heb412_mcdir_t) {
            d = (t - window.heb412_mcdir_t)/1000
          }
          // NO se permite mas de un envio en 2 segundos 
          if (d == -1 || d > 2) {
            window.heb412_mcdir_t = t
            switch (e.target.id) {
              case "abrir":
                window.heb412_mcdir_enlace.click()
                break
              case "renombrar":
                alert("renombrado directorio!")
                break
              case "eliminar":
                Heb412Gen__Motor.eliminarDirectorio(window.heb412_mcdir_enlace.href)
                break
              case "permisos":
                alert("estableciendo permisos a directorio!")
                break
            }
          }
        }

      })
    }
    return
  }

  // Llamar cada vez que se cargue una página detectada con turbo:load
  // Tal vez en cache por lo que podría no haberse ejecutado iniciar 
  // nuevamente.
  // Podría ser llamada varias veces consecutivas por lo que debe detectarlo
  // para no ejecutar dos veces lo que no conviene.
  static ejecutarAlCargarPagina() {
    console.log("* Corriendo Heb412Gen__Motor::ejecutarAlCargarPagina()")
  }

  // Se ejecuta desde app/javascript/application.js tras importar el motor
  static iniciar() {
    console.log("* Corriendo Heb412Gen__Motor::iniciar()")
  }



  // Pone parametros de formulario en enlace para generar plantilla
  // @elema this de boton Generar
  // @idselplantilla id del campo de seleccion de plantilla
  // @idruta ruta del formulario (e.g '/casos/filtro') si se deja
  //   en blanco se usa el mas cercano a elema
  // @rutagenera ruta por cargar con id de plantilla y valores del 
  //   formulario e.g 'casos/genera/'
  static completarEnlacePlantilla(
    elema, idselplantilla, idruta, rutagenera, formatosalida = 'ods'
  ) {
    let formato = formatosalida
    let p = $(idselplantilla).val().split('.')
    let nplantilla = p[0].replace(/[^a-zA-Z0-9_]/g, "")
    if (p.length == 2) {
      if (p[1] != 'html' && p[1] != 'ods' && p[1] != 'odt' && p[1] != 'xrlat' && p[1] != 'json' && p[1] != 'csv') {
        nplantilla = ''
      } else {
        formato = p[1]
        if (formato == 'html' || formato == 'odt' || formato == 'xrlat' || formato == 'json' || formato == 'csv') {
          formatosalida = formato
        }
      }
    }
    if (nplantilla.length > 0) {
      let f = null
      if (idruta == null) {
        f = $(elema).closest('form')
      } else {
        f = $("form[action$='" + idruta + "']")
      }
      let d = f.serialize()
      d += '&idplantilla=' +  nplantilla
      d += '&formato=' +  formato
      d += '&formatosalida=' +  formatosalida
      d += '&commit=Enviar'
      Msip__Motor.arreglarPuntoMontaje()
      if ((window.puntoMontaje != '/' || rutagenera[0] != '/') && 
        rutagenera.substring(0, window.puntoMontaje.length) != window.puntoMontaje
      ) {
        rutagenera = window.puntoMontaje + rutagenera
      }
      let e = rutagenera + '.' + formatosalida + '?' + d
      $(elema).attr('href', e)
    } else  {
      return false
    }
  }

  static eliminarArchivo(urlelim) {
    let el = document.createElement('a');
    el.href = urlelim
    let rnarc = el.pathname.replace(/^.*\/sis\/ */, '') + '/' + el.search.substr(10)
    let ub = rnarc.lastIndexOf('/')
    if (ub < 0) {
      return false
    }
    let rarc = rnarc.substr(0, ub)
    let narc = rnarc.substr(ub+1)
    Msip__Motor.enviarAjaxDatosRutaYPinta(
      'sis/eliminararc', {ruta: rarc, arc: narc}, '', '', 'POST', 
      'script', true
    )
  }

  static eliminarDirectorio(urlelim) {
    let el = document.createElement('a');
    el.href = urlelim
    let rnarc = el.pathname.replace(/^.*\/sis\/ */, '') 
    let ub = rnarc.lastIndexOf('/')
    if (ub < 0) {
      return false
    }
    let rarc = rnarc.substr(0, ub)
    let ndir = rnarc.substr(ub+1)
    Msip__Motor.enviarAjaxDatosRutaYPinta(
      'sis/eliminardir', {ruta: rarc, dir: ndir}, '', '', 'POST', 
      'script', true
    )
  }


}
