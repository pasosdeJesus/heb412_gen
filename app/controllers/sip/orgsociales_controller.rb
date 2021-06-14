# encoding: UTF-8
require_dependency "heb412_gen/concerns/controllers/orgsociales_controller"

module Sip
  class OrgsocialesController < Heb412Gen::ModelosController
    include Heb412Gen::Concerns::Controllers::OrgsocialesController
  end
end
