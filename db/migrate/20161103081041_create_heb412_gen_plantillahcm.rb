# frozen_string_literal: true

class CreateHeb412GenPlantillahcm < ActiveRecord::Migration[5.0]
  def change
    create_table(:heb412_gen_plantillahcm) do |t|
      t.string(:ruta, limit: 2047, null: false)
      t.string(:descripcion, limit: 2047)
      t.string(:fuente, limit: 1023)
      t.string(:licencia, limit: 1023)
      t.string(:vista, limit: 127, null: false)
      t.string(:nombremenu, limit: 127, null: false)
      t.integer(:filainicial, null: false)
    end
  end
end
