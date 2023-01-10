# frozen_string_literal: true

require "application_system_test_case"

class IniciarSesionTest < ApplicationSystemTestCase
  test "iniciar sesión" do
    Msip::CapybaraHelper.iniciar_sesion(self, root_path, "heb412", "heb412")
  end
end
