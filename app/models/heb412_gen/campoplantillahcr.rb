# frozen_string_literal: true

require "heb412_gen/concerns/models/campoplantillahcr"

module Heb412Gen
  # Campo en una plantilla de hoja de cáclulo para un registro
  class Campoplantillahcr < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Campoplantillahcr
  end
end
