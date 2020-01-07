class FormularioPlantillahcm < ActiveRecord::Migration[6.0]
  def change
    create_table :heb412_gen_formulario_plantillahcm, id: false do |t|
      t.integer :formulario_id
      t.integer :plantillahcm_id
    end
    add_foreign_key :heb412_gen_formulario_plantillahcm,
      :mr519_gen_formulario, 
      column: :formulario_id
    add_foreign_key :heb412_gen_formulario_plantillahcm,
      :heb412_gen_plantillahcm,
      column: :plantillahcm_id
  end
end
