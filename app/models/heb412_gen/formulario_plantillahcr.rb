# frozen_string_literal: true

require "heb412_gen/concerns/models/formulario_plantillahcr"
module Heb412Gen
  # Relación n:n entre formularios y plantillas para un registro
  class FormularioPlantillahcr < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::FormularioPlantillahcr
  end
end
