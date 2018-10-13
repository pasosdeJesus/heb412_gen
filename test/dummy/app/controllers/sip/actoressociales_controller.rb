# encoding: UTF-8

require 'sip/concerns/controllers/actoressociales_controller'

class Sip::ActoressocialesController < Heb412Gen::ModelosController

  include Sip::Concerns::Controllers::ActoressocialesController

  def vistas_manejadas
    ['Actorsocial']
  end

end
