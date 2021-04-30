class CreaCarpetaexclusiva < ActiveRecord::Migration[6.1]
  def change
    create_table :heb412_gen_carpetaexclusiva do |t|
      t.string :carpeta, limit: 2048
      t.integer :grupo_id
      t.timestamps
    end
    add_foreign_key :heb412_gen_carpetaexclusiva, :sip_grupo,
      column: :grupo_id
  end
end
