class IndiceCampoplantillahc < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      SELECT pg_catalog.setval('heb412_gen_campoplantillahcm_id_seq', MAX(id))
        FROM  (SELECT 1000 AS id UNION SELECT MAX(id) FROM 
        heb412_gen_campoplantillahcm) AS s;
      SELECT pg_catalog.setval('heb412_gen_campoplantillahcr_id_seq', MAX(id))
        FROM  (SELECT 1000 AS id UNION SELECT MAX(id) FROM 
        heb412_gen_campoplantillahcr) AS s;
    SQL
  end
  def down
  end
end
