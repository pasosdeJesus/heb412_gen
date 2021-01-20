#encoding: UTF-8 

module Heb412Gen
  module PlantillaHelper

    # Recibe una vista, posibles formularios y retorna los campos usables
    #   al generar una plantilla
    # @param v Vista
    # @param formularios Enumerable con formularios de los cuales sacar campos
    # @param agrega_ult_ed Agrega último editor
    def campos_vista_formulario(v, formularios, agrega_ult_ed)
      ab = ::Ability.new
      if v.nil? || ab.campos_plantillas[v].nil?
        col = [['','']]
      else
        col = ab.campos_plantillas[v][:campos]
      end
      if formularios
        formularios.each do |fr|
          nf=fr.nombreinterno
          if agrega_ult_ed
            col |= ["#{nf}.ultimo_editor"]
            col |= ["#{nf}.fecha_ultimaedicion"]
          end
          fr.campo.each do |c|
            puts "c=#{c.nombreinterno}"
            col |= ["#{nf}.#{c.nombreinterno}"]
            if c.tipo == Mr519Gen::ApplicationHelper::SELECCIONMULTIPLE
              c.opcioncs.each do |op|
                col |= ["#{nf}.#{c.nombreinterno}.#{op.valor}"]
              end
            end
          end
        end
      end
      col = col.localize(:es).to_a.map{|x| x.to_s}.sort
      puts "OJO campoplantillahcm. col=#{col.to_s}"
      return col
    end 
    module_function :campos_vista_formulario


    # Dado el nombre de una columna de una hoja de cálculo retorna la siguiente
    #
    # Supone que el nombre de la columna usa el alfabeto en inglés y en 
    # mayúsculas. Por ejemplo sigcol('A') es 'B', sigcol('Z') es 'AA'
    def sigcol(col)
      res = ''
      i = col.length - 1
      lleva = 1
      while i>=0
        if lleva == 1 && col[i] == 'Z'
          res = 'A' + res
          lleva = 1
        elsif lleva == 1
          c0 = col[i].ord + 1
          res = c0.chr + res
          lleva = 0
        else
          res = col[i] + res
        end
        i -=1
      end
      if lleva == 1
        res = 'A' + res
      end
      return res
    end
    module_function :sigcol

    # Dado el nombre de una columna de una hoja de cálculo retorna la anterior
    #
    # Supone que el nombre de la columna usa el alfabeto en inglés y en 
    # mayúsculas. Por ejemplo antcol('B') es 'A', antco('AA') es 'Z'
    def antcol(col)
      if col == ''
        raise "No puede calcular antcol(nil)"
      end
      res = ''
      i = col.length - 1
      resta = 1
      while i>=0
        if resta == 1 && col[i] == 'A' && i == 0
          # elimina saltando
        elsif resta == 1 && col[i] == 'A'
          res = 'Z' + res
          resta = 1
        elsif resta == 1
          c0 = col[i].ord - 1
          res = c0.chr + res
          resta = 0
        else
          res = col[i] + res
        end
        i -=1
      end
      return res
    end
    module_function :antcol


  end
end
