# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#//= require cocoon


# Pone parametros de formulario en enlace para generar plantilla
@heb412_gen_completa_generarp = (elema, idselplantilla, idform, rutagenera) ->
  #elema=this de boton Generar
  #idselplantilla='#filtro_disgenera' id del campo de seleccion de plantilla
  #idform='/casos/filtro' id del formulario cuyos valores se extraeran
  #rutagenera='casos/genera/' ruta por cargar con id de plantilla elegida y valores de formulario

  nplantilla = parseInt($(idselplantilla).val())

  if nplantilla > 0 
    f = $("form[action$='" + idform + "']")
    d = f.serialize()
    d += '&commit=Enviar'
    root =  window;
    sip_arregla_puntomontaje(root)
    e = root.puntomontaje + rutagenera + nplantilla + '?' + d
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

