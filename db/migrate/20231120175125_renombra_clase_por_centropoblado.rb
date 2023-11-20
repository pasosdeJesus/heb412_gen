class RenombraClasePorCentropoblado < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      UPDATE heb412_gen_campoplantillahcm 
        SET nombrecampo='centropoblado' 
        WHERE id=130;
    SQL
  end
  def down
    execute <<-SQL
      UPDATE heb412_gen_campoplantillahcm 
        SET nombrecampo='clase' 
        WHERE id=130;
    SQL
  end
end
