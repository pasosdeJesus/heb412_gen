# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#//= require cocoon


# Pone parametros de formulario en enlace para generar plantilla
# @elema this de boton Generar
# @idselplantilla id del campo de seleccion de plantilla
# @idruta ruta del formulario (e.g '/casos/filtro') si se deja
#   en blanco se usa el mas cercano a elema
# @rutagenera ruta por cargar con id e plantilla y valors del 
#   formulario e.g 'casos/genera/'
@heb412_gen_completa_generarp = (elema, idselplantilla, idruta, rutagenera) ->
  nplantilla = parseInt($(idselplantilla).val())

  if nplantilla > 0 
    if idruta == null
      f = $(elema).closest('form')
    else
      f = $("form[action$='" + idruta + "']")
    d = f.serialize()
    d += '&idplantilla=' +  nplantilla
    d += '&commit=Enviar'
    root =  window;
    sip_arregla_puntomontaje(root)
    e = root.puntomontaje + rutagenera + '.ods?' + d
    $(elema).attr('href', e)
  else 
    return false

@heb412_gen_prepara_eventos_comunes = (root) ->
  if window.location.href.match(/\/plantillahcm\//)
    $(document).on('change', '#plantillahcm_vista', (e) -> 
      return sip_envia_ajax_datos_ruta_y_pinta('plantillahcm/pintacampos',
        'vista=' + $(this).val(), '#gen_divcampos', '#divcampos')
    )

  return

