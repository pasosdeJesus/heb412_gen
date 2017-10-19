class PlantillaSinDescripcion < ActiveRecord::Migration[5.1]
  def change
    remove_column :heb412_gen_plantillahcm, :descripcion
  end
end
