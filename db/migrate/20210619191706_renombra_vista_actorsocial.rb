# frozen_string_literal: true

class RenombraVistaActorsocial < ActiveRecord::Migration[6.1]
  def up
    execute(<<-SQL)
      UPDATE heb412_gen_plantillahcm
        SET vista='Orgsocial' WHERE vista='Actorsocial';
      UPDATE heb412_gen_plantillahcr
        SET vista='Orgsocial' WHERE vista='Actorsocial';
    SQL
  end

  def down
    execute(<<-SQL)
      UPDATE heb412_gen_plantillahcr
        SET vista='Actorsocial' WHERE vista='Orgsocial';
      UPDATE heb412_gen_plantillahcm
        SET vista='Actorsocial' WHERE vista='Orgsocial';
    SQL
  end
end
