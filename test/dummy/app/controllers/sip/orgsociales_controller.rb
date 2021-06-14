# encoding: UTF-8

require 'sip/concerns/controllers/orgsociales_controller'

class Sip::OrgsocialesController < Heb412Gen::ModelosController

  include Sip::Concerns::Controllers::OrgsocialesController

  def vistas_manejadas
    ['Orgsocial']
  end

end
