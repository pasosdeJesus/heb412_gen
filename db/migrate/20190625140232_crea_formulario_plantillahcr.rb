# encoding: utf-8

class CreaFormularioPlantillahcr < ActiveRecord::Migration[6.0]
  def change
    create_table :heb412_gen_formulario_plantillahcr do |t|
      t.integer :plantillahcr_id
      t.integer :formulario_id
    end
    add_foreign_key :heb412_gen_formulario_plantillahcr,
      :mr519_gen_formulario, 
      column: :formulario_id
    add_foreign_key :heb412_gen_formulario_plantillahcr,
      :heb412_gen_plantillahcr,
      column: :plantillahcr_id
  end
end
