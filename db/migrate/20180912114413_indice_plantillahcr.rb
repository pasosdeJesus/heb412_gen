class IndicePlantillahcr < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      SELECT setval('heb412_gen_plantillahcr_id_seq', 100);
    SQL
  end
  def down
  end
end
