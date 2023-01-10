# frozen_string_literal: true

class CambiaActorSocialPorOrganizacionSocial < ActiveRecord::Migration[6.0]
  def up
    execute(<<-SQL)
      UPDATE heb412_gen_plantillahcm SET#{" "}
        nombremenu='Listado completo de organizaciones sociales',#{" "}
        ruta='plantillas/listado_organizacionessociales.ods'#{" "}
      WHERE nombremenu='Listado completo de actores sociales';
    SQL
  end

  def down
    execute(<<-SQL)
      UPDATE heb412_gen_plantillahcm SET#{" "}
        nombremenu='Listado completo de actores sociales',#{" "}
        ruta='plantillas/listado_actoressociales.ods'#{" "}
      WHERE nombremenu='Listado completo de organizaciones sociales';
    SQL
  end
end
