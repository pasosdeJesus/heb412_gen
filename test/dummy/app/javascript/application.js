/* eslint no-console:0 */

console.log('Hola Mundo desde ESM')

import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
Rails.start();
window.Rails = Rails

import './jquery'
import './jquery-ui'

import 'popper.js'              // Dialogos emergentes usados por bootstrap
import * as bootstrap from 'bootstrap'              // Maquetacion y elementos de diseño
import 'chosen-js/chosen.jquery';       // Cuadros de seleccion potenciados
import 'bootstrap-datepicker'
import 'bootstrap-datepicker/dist/locales/bootstrap-datepicker.es.min.js'

import 'gridstack'
let esperarRecursosSprocketsYDocumento = function (resolver) {
  if (typeof window.puntomontaje == 'undefined') {
    setTimeout(esperarRecursosSprocketsYDocumento, 100, resolver)
    return false
  }
  if (document.readyState !== 'complete') {
    setTimeout(esperarRecursosSprocketsYDocumento, 100, resolver)
    return false
  }
  resolver("Recursos manejados con sprockets cargados y documento presentado en navegador")
    return true
  }

let promesaRecursosSprocketsYDocumento = new Promise((resolver, rechazar) => {
  esperarRecursosSprocketsYDocumento(resolver)
})

promesaRecursosSprocketsYDocumento.then((mensaje) => {
  console.log(mensaje)
  var root = window;
  sip_prepara_eventos_comunes(root);
  mr519_gen_prepara_eventos_comunes(root);
  heb412_gen_prepara_eventos_comunes(root);
})

document.addEventListener('turbo:load', (e) => {
 /* Lo que debe ejecutarse cada vez que turbo cargue una página,
 * tener cuidado porque puede dispararse el evento turbo varias
 * veces consecutivas al cargarse  la misma página.
 */
  
  console.log('Escuchador turbo:load')

  sip_ejecutarAlCargarPagina(window)
})

