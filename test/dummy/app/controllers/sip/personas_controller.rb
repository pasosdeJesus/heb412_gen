# encoding: UTF-8

require 'sip/concerns/controllers/personas_controller'

class Sip::PersonasController < Heb412Gen::ModelosController

  include Sip::Concerns::Controllers::PersonasController

  def vistas_manejadas
    ['Persona']
  end

  def index(c = nil)
    super(c)
  end

end
