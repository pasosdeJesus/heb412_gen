require "sip/concerns/controllers/orgsociales_controller"

module Heb412Gen
  module Concerns
    module Controllers
      module OrgsocialesController

        extend ActiveSupport::Concern

        included do
          include ActionView::Helpers::AssetUrlHelper
          include Sip::FormatoFechaHelper
          include Sip::ModeloHelper

          include Sip::Concerns::Controllers::OrgsocialesController
 
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
