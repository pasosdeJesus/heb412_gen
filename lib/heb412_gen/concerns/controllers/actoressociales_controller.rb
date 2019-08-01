# encoding: UTF-8

require_dependency "sip/concerns/controllers/actoressociales_controller"

module Heb412Gen
  module Concerns
    module Controllers
      module ActoressocialesController

        extend ActiveSupport::Concern

        included do
          include ActionView::Helpers::AssetUrlHelper
          include Sip::FormatoFechaHelper
          include Sip::ModeloHelper

          include Sip::Concerns::Controllers::ActoressocialesController
 
          # La clase que incluya a este debe ser descendiente de
          # Heb412Gen::ModelosController

          def vistas_manejadas
            ['Actorsocial']
          end

        end # included

      end
    end
  end
end
