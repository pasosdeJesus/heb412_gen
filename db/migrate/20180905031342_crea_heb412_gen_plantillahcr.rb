# frozen_string_literal: true

class CreaHeb412GenPlantillahcr < ActiveRecord::Migration[5.2]
  def change
    create_table(:heb412_gen_plantillahcr) do |t|
      t.string(:ruta, limit: 2047)
      t.string(:fuente, limit: 1023)
      t.string(:licencia, limit: 1023)
      t.string(:vista, limit: 127)
      t.string(:nombremenu, limit: 127)
    end
  end
end
