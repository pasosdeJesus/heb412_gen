require_dependency 'heb412_gen/concerns/controllers/carpetasexclusivas_controller'

module Heb412Gen
  class CarpetasexclusivasController < Sip::ModelosController
 
    before_action :set_carpetaexclusiva, only: [:edit, :update, :destroy,
                                                :show, :impreso]
    load_and_authorize_resource  class: Heb412Gen::Carpetaexclusiva

    include Heb412Gen::Concerns::Controllers::CarpetasexclusivasController

  end
end
