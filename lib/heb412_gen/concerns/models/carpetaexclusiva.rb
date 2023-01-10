# frozen_string_literal: true

module Heb412Gen
  module Concerns
    module Models
      module Carpetaexclusiva
        extend ActiveSupport::Concern
        include Msip::Modelo

        included do
          belongs_to :grupo,
            class_name: "Msip::Grupo",
            validate: true,
            optional: false

          validates :carpeta, presence: true, length: { maximum: 2047 }
        end # included

        class_methods do
          def modelos_path
            "carpetasexclusivas_path"
          end
        end
      end
    end
  end
end
