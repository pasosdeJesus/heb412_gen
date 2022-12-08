require "msip/concerns/controllers/orgsociales_controller"

module Heb412Gen
  module Concerns
    module Controllers
      module OrgsocialesController

        extend ActiveSupport::Concern

        included do
          include ActionView::Helpers::AssetUrlHelper
          include Msip::FormatoFechaHelper
          include Msip::ModeloHelper

          include Msip::Concerns::Controllers::OrgsocialesController
 
          # La clase que incluya a este debe ser descendiente de
          # Heb412Gen::ModelosController

          def vistas_manejadas
            ['Orgsocial']
          end

        end # included

      end
    end
  end
end
