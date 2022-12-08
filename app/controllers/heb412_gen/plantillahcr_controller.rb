require 'heb412_gen/concerns/controllers/plantillahcr_controller'

module Heb412Gen
  class PlantillahcrController < Msip::ModelosController
 
    before_action :set_plantillahcr, only: [:edit, :update, :destroy, 
                                            :show, :impreso]
    load_and_authorize_resource  class: Heb412Gen::Plantillahcr

    include Heb412Gen::Concerns::Controllers::PlantillahcrController    

  end
end
