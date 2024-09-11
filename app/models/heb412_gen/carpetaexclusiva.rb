# frozen_string_literal: true

require "heb412_gen/concerns/models/carpetaexclusiva"

module Heb412Gen
  # Carpeta exclusiva para administradores en nube
  class Carpetaexclusiva < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Carpetaexclusiva
  end
end
