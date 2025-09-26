# frozen_string_literal: true

module Heb412Gen
  module Concerns
    module Controllers
      module PlantillasdocController
        extend ActiveSupport::Concern

        included do
          include ActionView::Helpers::AssetUrlHelper
          include Msip::FormatoFechaHelper
          include Msip::ModeloHelper

          helper ::ApplicationHelper

          def clase
            "Heb412Gen::Plantilladoc"
          end

          def atributos_show
            ["id", "ruta", "fuente", "licencia", "vista", "nombremenu"]
          end

          def atributos_index
            ["id", "vista", "nombremenu", "ruta", "licencia"]
          end

          def atributos_form
            atributos_show - ["id"]
          end

          def index_reordenar(c)
            c.reorder([:vista, :nombremenu])
          end

          def new_modelo_path(o)
            new_plantilladoc_path
          end

          def genclase
            "F"
          end

          private

          def set_plantilladoc
            @registro = @plantilladoc = Heb412Gen::Plantilladoc.find(
              Heb412Gen::Plantilladoc.connection.quote_string(
                params[:id],
              ).to_i,
            )
          end

          # No confiar parametros a Internet, sólo permitir lista blanca
          def plantilladoc_params
            params.require(:plantilladoc).permit(*atributos_form)
          end
        end # included
      end
    end
  end
end
