# frozen_string_literal: true

require "heb412_gen/concerns/models/campoplantillahcm"

module Heb412Gen
  # Columna donde se exporta un campo de un registro en una plantilla de 
  # hoja de cálculo para un conjunto de registros.
  class Campoplantillahcm < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Campoplantillahcm
  end
end
