class CreaHeb412GenCampoplantillahcr < ActiveRecord::Migration[5.2]
  def change
    create_table :heb412_gen_campoplantillahcr do |t|
      t.integer :plantillahcr_id
      t.string :nombrecampo, limit: 127 
      t.string :columna, limit: 5
      t.integer :fila
    end
  end
end
