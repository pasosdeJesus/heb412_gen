# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#//= require cocoon


# Pone parametros de formulario en enlace para generar plantilla
# @elema this de boton Generar
# @idselplantilla id del campo de seleccion de plantilla
# @idruta ruta del formulario (e.g '/casos/filtro') si se deja
#   en blanco se usa el mas cercano a elema
# @rutagenera ruta por cargar con id de plantilla y valores del 
#   formulario e.g 'casos/genera/'
@heb412_gen_completa_generarp = (elema, idselplantilla, idruta, rutagenera,
  formato = 'ods') ->

  #formato = 'ods'
  p = $(idselplantilla).val().split('.')
  nplantilla = p[0].replace(/[^a-zA-Z0-9_]/g, "")
  if p.length == 2
    if p[1] != 'html' && p[1] != 'ods' && p[1] != 'odt' && p[1] != 'xrlat' && p[1] != 'json'
      nplantilla = ''
    else
      formato = p[1]
  if nplantilla.length > 0 
    if idruta == null
      f = $(elema).closest('form')
    else
      f = $("form[action$='" + idruta + "']")
    d = f.serialize()
    d += '&idplantilla=' +  nplantilla
    d += '&commit=Enviar'
    root =  window;
    sip_arregla_puntomontaje(root)
    if (root.puntomontaje != '/' || rutagenera[0] != '/') && rutagenera.substring(0, root.puntomontaje.length) != root.puntomontaje
      rutagenera = root.puntomontaje + rutagenera
    e = rutagenera + '.' + formato + '?' + d
    $(elema).attr('href', e)
  else 
    return false

@heb412_gen_eliminar_archivo = (urlelim) ->
  el = document.createElement('a');
  el.href = urlelim
  rnarc = el.pathname.replace(/^.*\/sis\//, '') + '/' + el.search.substr(10)
  ub = rnarc.lastIndexOf('/')
  if ub < 0
    return false
  rarc = rnarc.substr(0, ub)
  narc = rnarc.substr(ub+1)
  sip_envia_ajax_datos_ruta_y_pinta('sis/eliminararc',
    {ruta: rarc, arc: narc}, '', '', 'POST', 'script')

@heb412_gen_eliminar_directorio = (urlelim) ->
  el = document.createElement('a');
  el.href = urlelim
  rnarc = el.pathname.replace(/^.*\/sis\//, '') 
  ub = rnarc.lastIndexOf('/')
  if ub < 0
    return false
  rarc = rnarc.substr(0, ub)
  ndir = rnarc.substr(ub+1)
  sip_envia_ajax_datos_ruta_y_pinta('sis/eliminardir',
    {ruta: rarc, dir: ndir}, '', '', 'POST', 'script')


@heb412_gen_prepara_eventos_comunes = (root) ->
  if window.location.href.match(/\/plantillahcm\//)
    $(document).on('change', '#plantillahcm_vista', (e) -> 
      return sip_envia_ajax_datos_ruta_y_pinta('plantillahcm/pintacampos',
        'vista=' + $(this).val(), '#gen_divcampos', '#divcampos')
    )

   
  # MENUS CONTEXTUALES
  $("#heb412_mcarc").hide();
  $("#heb412_mcdir").hide();
 
  $(".heb412_archivo").bind("contextmenu", (e) ->
    if e.target.nodeName == 'I' 
      if e.target.parentElement.nodeName == 'A'
        window.heb412_mcarc_descarga = e.target.parentElement
      else
        window.heb412_mcarc_descarga = e.target.parentElement.children[1]
    else
      window.heb412_mcarc_descarga = e.target.children[1]
    $("#heb412_mcarc").css({'display':'block', 'left':e.pageX, 'top':e.pageY });
    return false;
  )
  
  $(".heb412_directorio").bind("contextmenu", (e) ->
    window.heb412_mcdir_enlace = e.target
    $("#heb412_mcdir").css({'display':'block', 'left':e.pageX, 'top':e.pageY });
    return false;
  )
  
  $(document).click( (e) ->
    if e.button == 0
      $(".heb412_menucontextual").css("display", "none");
  )
            
  $(".heb412_menucontextual").mouseleave( () ->
    $(".heb412_menucontextual").hide("fast");
  )
  
  $(document).keydown( (e) ->
    if e.keyCode == 27
      $(".heb412_menucontextual").css("display", "none");
  )
  
  $("#heb412_mcarc").click((e) ->
    root = window
    sip_arregla_puntomontaje(root)
    t = Date.now()
    d = -1
    if (root.heb412_mcarc_t)
      d = (t - root.heb412_mcarc_t)/1000
    # NO se permite mas de un envio en 2 segundos 
    if (d == -1 || d > 2)
      root.heb412_mcarc_t = t
      switch e.target.id
        when "descargar" then root.heb412_mcarc_descarga.click()
        when "renombrar" then alert("renombrado archivo!")
        when "eliminar" then heb412_gen_eliminar_archivo(root.heb412_mcarc_descarga.href)
        when "permisos" then alert("estableciendo establecidos!")
    return false
  )

  $("#heb412_mcdir").click((e) ->
    t = Date.now()
    d = -1
    if (window.heb412_mcdir_t)
      d = (t - root.heb412_mcdir_t)/1000
    # NO se permite mas de un envio en 2 segundos 
    if (d == -1 || d > 2)
      window.heb412_mcdir_t = t
      switch e.target.id
        when "abrir" then window.heb412_mcdir_enlace.click()
        when "renombrar" then alert("renombrado directorio!")
        when "eliminar" then heb412_gen_eliminar_directorio(root.heb412_mcdir_enlace.href)
        when "permisos" then alert("estableciendo permisos a directorio!")
  )

  return

