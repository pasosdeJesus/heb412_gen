# frozen_string_literal: true

module Heb412Gen
  class GeneralistadoJob < ApplicationJob
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
    # 
    # @param idplantilla Id de la plantilla
    # @param cmodelo Clase del modelo
    # @param ccontrolador Clase del controlador
    # @param ids  Lista de ids por incluir en el reporte
    # @param narch Nombre de archivo por generar
    # @param parsimp Algunos parámetros simples y comunes ya reconocidos
    # @param extension Extensión del archivo por generar
    # @param campoid Id del campo que sirvie como id de la consulta
    # @param params listado completo de parámetros
    def perform(idplantilla, cmodelo, ccontrolador, ids, narch, parsimp,
      extension, campoid = :id, params = nil)
      puts "Inicio de generación de plantilla #{idplantilla}, con modelo #{cmodelo}, controlador #{ccontrolador}, cantidad de ids #{ids.length}, en #{narch}#{extension}"
      plant = Heb412Gen::Plantillahcm.find(idplantilla)
      controlador = ccontrolador.constantize
      modelo = cmodelo.constantize
      if controlador.respond_to?(:vista_listado)
        # Damos oportunidad de crear una vista si conviene
        vista = controlador.vista_listado(
          plant, ids, modelo, narch, parsimp, extension, campoid, params
        )
        if vista.class == String
          # Suponemos que ya generó hoja de cálculo
        end
        # Podría dar un arreglo con registros de los cuales extraer
        # la información --empleando los nombres de campos apropiados
        # o podría ser un objeto ActiveModel con las diversos registros
      else
        # Si no usamos los registros con las ids dadas para hacer
        # un ActiveModel
        vista = Heb412Gen::ModelosController.vista_listado(
          plant, ids, modelo, narch, parsimp, campoid, params
        )
      end
      if vista.class == String
        n = vista
      else
        fd = if vista.class == Array
          vista
        else
          controlador.cons_a_fd(
            vista,
            plant.campoplantillahcm.map(&:nombrecampo),
          )
        end
        ultp = 0
        n = Heb412Gen::PlantillahcmController
          .llena_plantilla_multiple_fd(plant, fd) do |t, i|
          p = 0
          if t > 0
            p = 100 * i / t
          end
          if p != ultp
            FileUtils.mv(
              "#{narch}#{extension}-#{ultp}",
              "#{narch}#{extension}-#{p}",
            )
            ultp = p
          end
        end
        FileUtils.mv("#{narch}#{extension}-#{ultp}", "#{narch}#{extension}-99")
      end
      nextension = if n.include?(".")
        "." + n.split(".")[-1]
      else
        ".ods"
      end
      if nextension == extension
        FileUtils.mv(n, "#{narch}#{extension}")
      else
        if File.exist?("#{narch}#{extension}")
          File.delete("#{narch}#{extension}")
        end
        dir = File.dirname(narch)
        bn = File.basename(narch)
        if n != "/tmp/#{bn}#{nextension}"
          FileUtils.mv(n, "/tmp/#{bn}#{nextension}")
        end

        if nextension == ".ods" && extension == ".pdf"
          res = %x(libreoffice --headless --convert-to pdf "/tmp/#{bn}#{nextension}" --outdir #{dir})
        elsif nextension == ".ods" && extension == ".xlsx"
          res = %x(libreoffice --headless --convert-to xlsx "/tmp/#{bn}#{nextension}" --outdir #{dir})
        elsif nextension == ".xlsx" && extension == ".ods"

          res = %x(libreoffice --headless --convert-to ods "/tmp/#{bn}#{nextension}" --outdir #{dir})
        elsif nextension == ".xlsx" && extension == ".pdf"

          res = %x(libreoffice --headless --convert-to pdf "/tmp/#{bn}#{nextension}" --outdir #{dir})
        end

        puts "OJO res=#{res}, n=#{n}, dir=#{dir}, bn=#{bn}"
        File.delete("/tmp/#{bn}#{nextension}")
      end
      FileUtils.rm_f("#{narch}#{extension}-99")
      puts "Fin de generación de plantilla #{idplantilla} en #{narch}"
    end
  end
end
