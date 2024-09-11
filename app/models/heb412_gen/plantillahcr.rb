# frozen_string_literal: true

require "heb412_gen/concerns/models/plantillahcr"

module Heb412Gen
  # Plantilla de hoja de cálculo para un registro
  class Plantillahcr < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Plantillahcr
  end
end
