# frozen_string_literal: true

class CrearTablaCampohc < ActiveRecord::Migration[5.0]
  def change
    create_table(:heb412_gen_campohc) do |t|
      t.integer(:doc_id, null: false)
      t.string(:nombrecampo, limit: 127, null: false) # en sistema de información
      t.string(:columna, limit: 5, null: false)
      t.integer(:fila) # Se ignora en el caso de plantilla para multiples registros
    end
    add_foreign_key(:heb412_gen_campohc, :heb412_gen_doc, column: :doc_id)
  end
end
