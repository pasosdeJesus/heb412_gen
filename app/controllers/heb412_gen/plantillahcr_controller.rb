# encoding: UTF-8

require_dependency 'heb412_gen/concerns/controllers/plantillahcr_controller'

module Heb412Gen
  class PlantillahcrController < Sip::ModelosController
 
    include Heb412Gen::Concerns::Controllers::PlantillahcrController    

  end
end
