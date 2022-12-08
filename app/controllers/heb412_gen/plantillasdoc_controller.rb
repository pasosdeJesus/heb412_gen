require 'heb412_gen/concerns/controllers/plantillasdoc_controller'

module Heb412Gen
  class PlantillasdocController < Msip::ModelosController
 
    before_action :set_plantilladoc, 
      only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource  class: Heb412Gen::Plantilladoc

    include Heb412Gen::Concerns::Controllers::PlantillasdocController    

  end
end
