class CambiaCotejacionNombresCampos < ActiveRecord::Migration[7.1]
  include Msip::SqlHelper

  def up
    cambiar_cotejacion(
      "heb412_gen_campoplantillahcr", "nombrecampo", 127, "es_co_utf_8"
    )
    cambiar_cotejacion(
      "heb412_gen_campoplantillahcm", "nombrecampo", 183, "es_co_utf_8"
    )
  end
  def down
    cambiar_cotejacion(
      "heb412_gen_campoplantillahcm", "nombrecampo", 127, nil
    )
    cambiar_cotejacion(
      "heb412_gen_campoplantillahcm", "nombrecampo", 183, nil
    )
  end
end
