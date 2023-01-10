# frozen_string_literal: true

module Heb412Gen
  module Concerns
    module Controllers
      module CarpetasexclusivasController
        extend ActiveSupport::Concern

        included do
          include ActionView::Helpers::AssetUrlHelper
          include Msip::FormatoFechaHelper
          include Msip::ModeloHelper

          def gencalse
            "F"
          end

          def clase
            "Heb412Gen::Carpetaexclusiva"
          end

          def atributos_show
            [
              :id,
              :carpeta,
              :grupo,
            ]
          end

          def atributos_index
            [
              :carpeta,
              :grupo,
            ]
          end

          def index_reordenar(c)
            c.reorder([:carpeta, :grupo_id])
          end

          private

          # Use callbacks to share common setup or constraints between actions.
          def set_carpetaexclusiva
            @registro = @carpetaexclusiva = Carpetaexclusiva.find(params[:id])
          end

          def lista_params
            [
              :id,
              :grupo_id,
              :carpeta,
            ]
          end

          def carpetaexclusiva_params
            params.require(:carpetaexclusiva).permit(lista_params)
          end
        end
      end
    end
  end
end
