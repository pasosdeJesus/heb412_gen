require 'msip/concerns/controllers/orgsociales_controller'

class Msip::OrgsocialesController < Heb412Gen::ModelosController

  before_action :set_orgsocial, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource class: Msip::Orgsocial

  include Msip::Concerns::Controllers::OrgsocialesController

  def vistas_manejadas
    ['Orgsocial']
  end

end
