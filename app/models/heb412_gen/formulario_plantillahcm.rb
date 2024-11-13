# frozen_string_literal: true

require "heb412_gen/concerns/models/formulario_plantillahcm"


module Heb412Gen
  # Relación n:n entre formularios y plantillas para un conjunto de registros
  class FormularioPlantillahcm < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::FormularioPlantillahcm
  end
end
