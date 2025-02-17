# frozen_string_literal: true

require "msip/concerns/controllers/personas_controller"

class Msip::PersonasController < Heb412Gen::ModelosController
  include Msip::Concerns::Controllers::PersonasController

  def vistas_manejadas
    ["Persona"]
  end

  def index(c = nil)
    super
  end
end
