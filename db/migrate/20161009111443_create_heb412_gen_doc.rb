# frozen_string_literal: true

class CreateHeb412GenDoc < ActiveRecord::Migration[5.0]
  def change
    create_table(:heb412_gen_doc) do |t|
      t.string(:nombre, limit: 512)
      t.string(:tipodoc, limit: 1)
      t.integer(:dirpapa)
      t.string(:url, limit: 1024)
      t.string(:fuente, limit: 1024)
      t.string(:descripcion, limit: 5000)
      t.timestamp(:created_at, null: false)
      t.timestamp(:updated_at, null: false)
    end
    add_foreign_key(:heb412_gen_doc, :heb412_gen_doc, column: :dirpapa)
  end
end
