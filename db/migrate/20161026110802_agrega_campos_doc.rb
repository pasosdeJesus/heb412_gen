# frozen_string_literal: true

class AgregaCamposDoc < ActiveRecord::Migration[5.0]
  def change
    add_column(:heb412_gen_doc, :nombremenu, :string, limit: 127)
    add_column(:heb412_gen_doc, :vista, :string, limit: 255)
    add_column(:heb412_gen_doc, :filainicial, :integer)
  end
end
