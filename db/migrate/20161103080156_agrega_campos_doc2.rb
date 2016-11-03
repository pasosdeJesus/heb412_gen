class AgregaCamposDoc2 < ActiveRecord::Migration[5.0]
  def change
    add_column :heb412_gen_doc, :ruta, :string, limit: 2047
    add_column :heb412_gen_doc, :licencia, :string, limit: 255
    add_column :heb412_gen_doc, :tdoc_id, :integer # Asociación polimórfica
    add_column :heb412_gen_doc, :tdoc_type, :string # Asociación polimórfica
    add_index :heb412_gen_doc, [:tdoc_type, :tdoc_id]
  end
end
