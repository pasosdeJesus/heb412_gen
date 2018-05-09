# encoding: UTF-8

require_dependency 'heb412_gen/concerns/controllers/plantillasdoc_controller'

module Heb412Gen
  class PlantillasdocController < Sip::ModelosController
 
    include Heb412Gen::Concerns::Controllers::PlantillasdocController    

  end
end
