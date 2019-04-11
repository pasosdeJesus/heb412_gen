# encoding: utf-8
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
    def perform(idplantilla, cmodelo, ccontrolador, ids, narch, parsimp,
                extension)
      puts "Inicio de generación de plantilla #{idplantilla}, con modelo #{cmodelo}, controlador #{ccontrolador}, cantidad de ids #{ids.length}, en #{narch}#{extension}"
      plant = Heb412Gen::Plantillahcm.find(idplantilla)
      controlador = ccontrolador.constantize
      modelo = cmodelo.constantize
      if controlador.respond_to?(:vista_listado)
        # Damos oportunidad de crear una vista si conviene
        vista = controlador.vista_listado(
          plant, ids, modelo, narch, parsimp, extension)
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
          plant, ids, modelo, narch, parsimp)
      end
      if vista.class == String
        n = vista
      else
        if vista.class == Array
          fd = vista
        else
          fd = controlador.cons_a_fd(vista, 
                                     plant.campoplantillahcm.map(&:nombrecampo))
        end
        ultp = 0
        n = Heb412Gen::PlantillahcmController.
          llena_plantilla_multiple_fd(plant, fd) do |t, i|
          p = 0
          if t>0
            p = 100*i/t
          end
          if p != ultp
            FileUtils.mv("#{narch}#{extension}-#{ultp}", 
                         "#{narch}#{extension}-#{p}")
                         ultp = p
          end
        end
        FileUtils.rm("#{narch}#{extension}-#{ultp}")
      end
      if extension == '.ods'
        FileUtils.mv(n, "#{narch}#{extension}")
      elsif extension == '.pdf'
        if File.exist?("#{n}.pdf")
          File.delete("#{n}.pdf")
        end
        dir = File.dirname(narch)
        bn = File.basename(narch)
        FileUtils.mv(n, "/tmp/#{bn}")
        res = `libreoffice --headless --convert-to pdf "/tmp/#{bn}" --outdir #{dir}`
        puts "OJO res=#{res}, n=#{n}, dir=#{dir}, bn=#{bn}"
        File.delete("/tmp/#{bn}")

      elsif extension == '.xlsx'
        if File.exist?("#{n}.xlsx")
          File.delete("#{n}.xlsx")
        end
        dir = File.dirname(narch)
        bn = File.basename(narch)
        FileUtils.mv(n, "/tmp/#{bn}")
        res = `libreoffice --headless --convert-to xlsx "/tmp/#{bn}" --outdir #{dir}`
        puts "OJO res=#{res}, n=#{n}, dir=#{dir}, bn=#{bn}"
        File.delete("/tmp/#{bn}")
      end
      puts "Fin de generación de plantilla #{idplantilla} en #{narch}"
    end

  end
end

