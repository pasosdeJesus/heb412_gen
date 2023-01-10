# frozen_string_literal: true

class CreateHeb412GenPlantilladoc < ActiveRecord::Migration[5.2]
  def up
    create_table(:heb412_gen_plantilladoc) do |t|
      t.string(:ruta, limit: 2047)
      t.string(:fuente, limit: 1023)
      t.string(:licencia, limit: 1023)
      t.string(:vista, limit: 127)
      t.string(:nombremenu, limit: 127)
    end
    execute(<<-SQL)
      SELECT pg_catalog.setval('heb412_gen_plantilladoc_id_seq', 100, false);
    SQL
  end

  def down
    drop_table(:heb412_gen_plantilladoc)
  end
end
