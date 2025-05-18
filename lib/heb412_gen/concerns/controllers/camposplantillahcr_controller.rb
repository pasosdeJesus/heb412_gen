# frozen_string_literal: true

module Heb412Gen
  module Concerns
    module Controllers
      module CamposplantillahcrController
        extend ActiveSupport::Concern

        included do
          def destroy
          end

          def create
          end

          private

          def preparar_plantillahcr
            @registro = @plantillahcr = Heb412Gen::Plantillahcr.new(
              campoplantillahcr: [Heb412Gen::Campoplantillahcr.new],
            )
          end
        end # included
      end
    end
  end
end
