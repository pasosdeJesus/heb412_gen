/* eslint no-console:0 */

console.log('Hola Mundo desde ESM')

import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
Rails.start();
window.Rails = Rails

import 'popper.js'              // Dialogos emergentes usados por bootstrap
import * as bootstrap from 'bootstrap'              // Maquetacion y elementos de diseño

import 'gridstack'

import Msip__Motor from "./controllers/msip/motor"
window.Msip__Motor = Msip__Motor
Msip__Motor.iniciar()
import Mr519Gen__Motor from "./controllers/mr519_gen/motor"
window.Mr519Gen__Motor = Mr519Gen__Motor
Mr519Gen__Motor.iniciar()
import Heb412Gen__Motor from "./controllers/heb412_gen/motor"
window.Heb412Gen__Motor = Heb412Gen__Motor
Heb412Gen__Motor.iniciar()

import TomSelect from 'tom-select';
window.TomSelect = TomSelect;
window.configuracionTomSelect = {
    create: false,
    diacritics: true, //no sensitivo a acentos
    sortField: {
          field: "text",
          direction: "asc"
        }
}
import {AutocompletaAjaxExpreg} from '@pasosdejesus/autocompleta_ajax'
window.AutocompletaAjaxExpreg = AutocompletaAjaxExpreg

let esperarRecursosSprocketsYDocumento = function (resolver) {
  if (typeof window.puntoMontaje == 'undefined') {
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
  // Este se ejecuta cada vez que se carga una página
  console.log(mensaje)
  Mr519Gen__Motor.ejecutarAlCargarDocumentoYRecursos()
  Heb412Gen__Motor.ejecutarAlCargarDocumentoYRecursos()
  Msip__Motor.ejecutarAlCargarDocumentoYRecursos()
})

document.addEventListener('turbo:load', (e) => {
 /* Lo que debe ejecutarse cada vez que turbo cargue una página,
 * tener cuidado porque puede dispararse el evento turbo varias
 * veces consecutivas al cargarse  la misma página.
 */
  
  console.log('Escuchador turbo:load')
  Msip__Motor.ejecutarAlCargarPagina()
  Mr519Gen__Motor.ejecutarAlCargarPagina()
  Heb412Gen__Motor.ejecutarAlCargarPagina()
  Heb412Gen__Motor.ejecutarAlCargarDocumentoYRecursos()
})

import "./controllers"
