# frozen_string_literal: true

require "heb412_gen/version"

Msip.setup do |config|
  config.ruta_anexos = ENV.fetch(
    "MSIP_RUTA_ANEXOS",
    "#{Rails.root}/archivos/anexos",
  )
  config.ruta_volcados = ENV.fetch(
    "MSIP_RUTA_VOLCADOS",
    "#{Rails.root}/archivos/bd",
  )
  # En heroku los anexos son super-temporales
  unless ENV["HEROKU_POSTGRESQL_GREEN_URL"].nil?
    config.ruta_anexos = "#{Rails.root}/tmp/"
  end
  config.titulo = "Heb412Gen #{Heb412Gen::VERSION}"

  config.descripcion = "Motor para manejar nube y plantillas en hoja de cálculo"
  config.codigofuente = "https://gitlab.com/pasosdeJesus/heb412_gen"
  config.urlcontribuyentes = "https://gitlab.com/pasosdeJesus/heb412_gen/-/graphs/main"
  config.urlcreditos = "https://gitlab.com/pasosdeJesus/heb412_gen/-/blob/master/CREDITOS.md"
  config.agradecimientoDios = "<p>
Agradecemos a Jesús/Dios por su Santo Espíritu que nos recuerda su Palabra
</p>
<blockquote>
<p>
Porque la palabra de Dios es viva y eficaz, y más cortante que
toda espada de dos filos; y penetra hasta partir el alma y el espíritu,
las coyunturas y los tuétanos y discierne los pensamientos
y las intenciones del corazón.
</p>
<p>Hebreos 4:12</p>
</blockquote>".html_safe
end
