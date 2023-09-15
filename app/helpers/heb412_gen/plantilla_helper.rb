# frozen_string_literal: true

module Heb412Gen
  module PlantillaHelper
    # Recibe una vista, posibles formularios y retorna los campos usables
    #   al generar una plantilla
    # @param v Vista
    # @param formularios Enumerable con formularios de los cuales sacar campos
    # @param agrega_ult_ed Agrega último editor
    def campos_vista_formulario(v, formularios, agrega_ult_ed)
      ab = ::Ability.new
      col = if v.nil? || Ability::campos_plantillas[v].nil?
        [["", ""]]
      else
        Ability::campos_plantillas[v][:campos]
      end
      if formularios
        formularios.each do |fr|
          nf = fr.nombreinterno
          if agrega_ult_ed
            col |= ["#{nf}.ultimo_editor"]
            col |= ["#{nf}.fecha_ultimaedicion"]
          end
          fr.campo.each do |c|
            puts "c=#{c.nombreinterno}"
            col |= ["#{nf}.#{c.nombreinterno}"]
            next unless c.tipo == Mr519Gen::ApplicationHelper::SELECCIONMULTIPLE

            c.opcioncs.each do |op|
              col |= ["#{nf}.#{c.nombreinterno}.#{op.valor}"]
            end
          end
        end
      end
      col = col.localize(:es).to_a.map { |x| x.to_s }.sort
      puts "OJO campoplantillahcm. col=#{col}"
      col
    end
    module_function :campos_vista_formulario

    # Dado el nombre de una columna de una hoja de cálculo retorna la siguiente
    #
    # Supone que el nombre de la columna usa el alfabeto en inglés y en
    # mayúsculas. Por ejemplo sigcol('A') es 'B', sigcol('Z') es 'AA'
    def sigcol(col)
      res = ""
      i = col.length - 1
      lleva = 1
      while i >= 0
        if lleva == 1 && col[i] == "Z"
          res = "A" + res
          lleva = 1
        elsif lleva == 1
          c0 = col[i].ord + 1
          res = c0.chr + res
          lleva = 0
        else
          res = col[i] + res
        end
        i -= 1
      end
      if lleva == 1
        res = "A" + res
      end
      res
    end
    module_function :sigcol

    # Dado el nombre de una columna de una hoja de cálculo retorna la anterior
    #
    # Supone que el nombre de la columna usa el alfabeto en inglés y en
    # mayúsculas. Por ejemplo antcol('B') es 'A', antco('AA') es 'Z'
    def antcol(col)
      if col == ""
        raise "No puede calcular antcol(nil)"
      end

      res = ""
      i = col.length - 1
      resta = 1
      while i >= 0
        if resta == 1 && col[i] == "A" && i == 0
          # elimina saltando
        elsif resta == 1 && col[i] == "A"
          res = "Z" + res
          resta = 1
        elsif resta == 1
          c0 = col[i].ord - 1
          res = c0.chr + res
          resta = 0
        else
          res = col[i] + res
        end
        i -= 1
      end
      res
    end
    module_function :antcol

    # Compara columnas de hoja de cálculo col1 y col2,
    # -1 si col1 es menor que col1
    # 0 si son iguales
    # 1 si col1 es mayor que col2
    def compara_columnas(col1, col2)
      if col1.length < col2.length
        return -1
      end
      if col2.length < col1.length
        return 1
      end

      # col1.length == col2.length
      i = 0
      i += 1 while i < col1.length && col1[i] == col2[i]

      if i < col1.length
        if col1[i] < col2[i]
          return -1
        else
          return 1
        end
      end

      0
    end
    module_function :compara_columnas

    # En la plantillahcm para hoja de cálculo con id plantillahcm_id,
    # emula operación en una hoja de cálculo de insertar una nueva
    # columna a la izquierda de la columna col. Y para poner en la nueva
    # columna col crea un nuevo campoplantillahcm la id y nombrecampo
    # recibidos por parámetros
    #
    # @param id Nuevo id por crear para un campoplantillahcm (no debe haber
    # otro con ese id).
    def inserta_columna(plantillahcm_id, id, col, nombrecampo)
      cols = Heb412Gen::Campoplantillahcm
        .where(plantillahcm_id: plantillahcm_id).pluck(:id, :columna)
      cols.each do |icol|
        comp = compara_columnas(icol[1], col)
        next unless comp >= 0

        c = Heb412Gen::Campoplantillahcm.find(icol[0])
        c.columna = Heb412Gen::PlantillaHelper.sigcol(c.columna)
        c.save!(validate: false) # Permitir columnas repetidas temporalmente
      end
      Heb412Gen::Campoplantillahcm.create!(
        id: id,
        plantillahcm_id: plantillahcm_id,
        nombrecampo: nombrecampo,
        columna: col,
      )
    end
    module_function :inserta_columna

    # En la plantillahcm para hoja de cálculo con id plantillahcm_id,
    # y uno de sus campos con la id dada, digamos en la columna col,
    # emula operación en una hoja de cálculo de eliminar la col-esima
    # columna (que desplaza todas las columnas a la derecha de la col-esima
    # una posición a la izquierda)
    #
    # @param id Nuevo id por crear para un campoplantillahcm (no debe haber
    # otro con ese id).
    def elimina_columna(plantillahcm_id, id)
      pore = Heb412Gen::Campoplantillahcm
        .where(plantillahcm_id: plantillahcm_id).where(id: id).take
      unless pore
        raise "No se encontró columna con id #{id} en "\
          "plantilla con id #{plantillahcm_id}"
      end
      col = pore.columna
      pore.destroy

      cols = Heb412Gen::Campoplantillahcm
        .where(plantillahcm_id: plantillahcm_id)
        .pluck(:id, :columna)

      cols.each do |icol|
        comp = compara_columnas(icol[1], col)
        next unless comp > 0

        # Mueve cada una de las que esté a la derecha de la col-esima
        c = Heb412Gen::Campoplantillahcm.find(icol[0])
        c.columna = Heb412Gen::PlantillaHelper.antcol(c.columna)
        c.save!(validate: false) # Permitir columnas repetidas temporalmente
      end
    end
    module_function :elimina_columna

    # Convierte el número de una columna a su representación en hoja de cálculo
    # como letras
    # 1 es A
    # 2 es B
    # ...
    # 26 es Z
    # 27 es AA
    # ...
    def numero_a_columna(n)
      if n <= 0
        return ""
      end
      lini = n
      col = ""
      loop do
        letrafin= ((lini - 1) % 26) + 65
        col = letrafin.chr + col
        lini = (lini - 1) / 26
        break if lini <= 0
      end
      return col
    end
    module_function :numero_a_columna

  end
end
