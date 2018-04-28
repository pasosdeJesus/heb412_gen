class ReservaPlantillasMotores < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      SELECT pg_catalog.setval('heb412_gen_plantillahcm_id_seq', 
        1 + GREATEST(MAX(id), 100), false) FROM heb412_gen_plantillahcm;
      SELECT pg_catalog.setval('heb412_gen_campoplantillahcm_id_seq', 
        1 + GREATEST(MAX(id), 100), false) FROM heb412_gen_campoplantillahcm;
    SQL
  end
  def down
  end
end
