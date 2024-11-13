# frozen_string_literal: true

module Heb412Gen
  module Concerns
    module Models
      module FormularioPlantillahcm
        extend ActiveSupport::Concern

        included do

          belongs_to :plantillahcm,
            class_name: "::Heb412Gen::Plantillahcm",
            optional: false
          belongs_to :formulario,
            class_name: "::Heb412Gen::Formulario",
            optional: false

        end

      end
    end
  end
end
