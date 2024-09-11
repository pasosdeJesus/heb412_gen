# frozen_string_literal: true

require "heb412_gen/concerns/models/plantillahcm"

module Heb412Gen
  # Plantilla de hoja de cálculo para un conjunto de registros
  class Plantillahcm < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Plantillahcm
  end
end
