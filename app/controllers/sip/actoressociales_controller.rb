# encoding: UTF-8
require_dependency "heb412_gen/concerns/controllers/actoressociales_controller"

module Sip
  class ActoressocialesController < Heb412Gen::ModelosController
    include Heb412Gen::Concerns::Controllers::ActoressocialesController
  end
end
