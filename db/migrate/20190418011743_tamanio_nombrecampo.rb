# frozen_string_literal: true

class TamanioNombrecampo < ActiveRecord::Migration[5.2]
  def up
    change_column(
      :heb412_gen_campoplantillahcm,
      :nombrecampo,
      :string,
      limit: 183,
    )
  end

  def down
    change_column(
      :heb412_gen_campoplantillahcm,
      :nombrecampo,
      :string,
      limit: 127,
    )
  end
end
