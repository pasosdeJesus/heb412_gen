# frozen_string_literal: true

module Heb412Gen
  module Concerns
    module Models
      module Campohc
        extend ActiveSupport::Concern

        included do
          belongs_to :doc,
            class_name: "::Heb412Gen::Doc",
            optional: false

          validates :nombrecampo,
            uniqueness: {
              scope: :doc_id,
              message: "no puede haber campos repetidos",
            }

          # Validación de unicidad de columna para hoja de cálculo para listados toca en controlador
        end # included
      end
    end
  end
end
