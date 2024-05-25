# frozen_string_literal: true

module Heb412Gen
  module Concerns
    module Models
      module Campoplantillahcr
        extend ActiveSupport::Concern

        included do
          belongs_to :plantillahcr,
            class_name: "::Heb412Gen::Plantillahcr",
            optional: false,
            validate: true

          validates :nombrecampo,
            allow_blank: false,
            length: { minimum: 1 },
            presence: true

          validates :columna,
            allow_blank: false,
            length: { minimum: 1 },
            presence: true,
            uniqueness: {
              scope: [:plantillahcr_id, :fila],
              message: "no puede haber celdas repetidas",
            }

          validates :fila,
            allow_blank: false,
            numericality: { greater_than: 0 },
            presence: true

          def presenta_nombre
            nombrecampo
          end
        end # included
      end
    end
  end
end
