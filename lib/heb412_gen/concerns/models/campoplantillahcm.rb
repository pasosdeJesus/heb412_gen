# frozen_string_literal: true

module Heb412Gen
  module Concerns
    module Models
      module Campoplantillahcm
        extend ActiveSupport::Concern

        included do
          belongs_to :plantillahcm,
            class_name: "::Heb412Gen::Plantillahcm",
            optional: false,
            validate: true

          validates :nombrecampo,
            presence: true,
            allow_blank: false,
            length: { minimum: 1, maximum: 183 }
          # El máximo es para permitir formulario.camposm.valor con
          # cada parte de 60 caracteres

          validates :columna,
            uniqueness: {
              scope: :plantillahcm_id,
              message: "no puede haber columnas repetidas",
            },
            presence: true,
            allow_blank: false,
            length: { minimum: 1 }
        end # included
      end
    end
  end
end
