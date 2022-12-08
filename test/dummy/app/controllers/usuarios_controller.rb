require 'msip/concerns/controllers/usuarios_controller'

class UsuariosController < Heb412Gen::ModelosController

  include Msip::Concerns::Controllers::UsuariosController

  def vistas_manejadas
    ['Usuario']
  end

end
