# encoding: UTF-8

require_dependency 'heb412_gen/concerns/controllers/plantillahcm_controller'

module Heb412Gen
  class PlantillahcmController < Sip::ModelosController
 
    include Heb412Gen::Concerns::Controllers::PlantillahcmController    

  end
end
