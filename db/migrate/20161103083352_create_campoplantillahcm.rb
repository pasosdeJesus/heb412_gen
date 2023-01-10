# frozen_string_literal: true

class CreateCampoplantillahcm < ActiveRecord::Migration[5.0]
  def change
    create_table(:heb412_gen_campoplantillahcm) do |t|
      t.integer(:plantillahcm_id)
      t.string(:nombrecampo, limit: 127)
      t.string(:columna, limit: 5)
    end
    add_foreign_key(
      :heb412_gen_campoplantillahcm,
      :heb412_gen_plantillahcm,
      column: :plantillahcm_id,
    )
  end
end
