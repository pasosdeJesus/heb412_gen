# frozen_string_literal: true

require "heb412_gen/concerns/models/campoplantillahcm"

# Campo en una plantilla de hoja de cálculo para un conjunto de registros
module Heb412Gen
  class Campoplantillahcm < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Campoplantillahcm
  end
end
