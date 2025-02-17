# frozen_string_literal: true

module Heb412Gen
  module Concerns
    module Controllers
      module CamposplantillahcmController
        extend ActiveSupport::Concern

        included do
          def destroy
          end

          def create
          end

          private

          def preparar_plantillahcm
            @registro = @plantillahcm = Heb412Gen::Plantillahcm.new(
              campoplantillahcm: [Heb412Gen::Campoplantillahcm.new],
            )
          end
        end # included
      end
    end
  end
end
