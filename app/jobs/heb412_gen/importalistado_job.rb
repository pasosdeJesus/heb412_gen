module Heb412Gen
  class ImportalistadoJob < ApplicationJob
    queue_as :default
 
    # Llena plantilla hoja de calculo con id idplantilla
    # a partir de los datos del modelo cmodelo con identificaciones ids,
    # empleando funciones de clase del controlador ccontrolador
    # y generando el archivo narch.
    #
    # Para lograr una generación rápida y con la información que se desee
    # da oportunidad de:
    # 1. crear una vista en la base de datos --si no se especifica se
    #    usarán los registros filtrados en el listado
    # 2. convertir de la base de datos a objetos ruby usando el método presenta
    def perform(idplantilla, nomcontrolador, narchent, narcherr, extension, ulteditor_id)
      puts "Inicio de generación de plantilla #{idplantilla} con nomcontrolador #{nomcontrolador}, importando de #{narchent} escribiendo errores en #{narcherr} con extensión #{extension} ulteditor_id es #{ulteditor_id}"
      plant = Heb412Gen::Plantillahcm.find(idplantilla)
      controlador = nomcontrolador.constantize.new
      modelo = controlador.clase
      #fd = controlador.arch_a_fd(narchent, 
      #                           plant.campoplantillahcm.map(&:nombrecampo) + 
      #                          ['_errores'])
      ultp = 0
      n = Heb412Gen::PlantillahcmController.
        llena_plantilla_multiple_importadatos(
          plant, controlador, modelo, narchent, ulteditor_id) do |t, i|
        p = 0
        if t>0
          p = 100*i/t
        end
        if p != ultp
          FileUtils.mv("#{narcherr}#{extension}-#{ultp}", 
                       "#{narcherr}#{extension}-#{p}")
                       ultp = p
        end
      end
      if !n.nil?
        FileUtils.rm("#{narcherr}#{extension}-#{ultp}")
        Heb412Gen::PlantillahcmController::
          convierte_a_extension_esperada(n, narcherr, extension)
      end
    end

  end
end

