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
      byebug
      col = col.localize(:es).sort.to_a
      byebug
      puts "OJO campoplantillahcm. col=#{col.to_s}"
      return col
    end 
    module_function :campos_vista_formulario

  end
end
