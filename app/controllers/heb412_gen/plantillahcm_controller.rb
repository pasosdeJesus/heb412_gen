require_dependency 'heb412_gen/concerns/controllers/plantillahcm_controller'

module Heb412Gen
  class PlantillahcmController < Sip::ModelosController
 
    before_action :set_plantillahcm, only: [:edit, :update, :destroy, 
                                            :show, :impreso]
    load_and_authorize_resource  class: Heb412Gen::Plantillahcm

    include Heb412Gen::Concerns::Controllers::PlantillahcmController    

  end
end
