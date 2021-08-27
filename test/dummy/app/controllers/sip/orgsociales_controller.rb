require 'sip/concerns/controllers/orgsociales_controller'

class Sip::OrgsocialesController < Heb412Gen::ModelosController

  before_action :set_orgsocial, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource class: Sip::Orgsocial

  include Sip::Concerns::Controllers::OrgsocialesController

  def vistas_manejadas
    ['Orgsocial']
  end

end
