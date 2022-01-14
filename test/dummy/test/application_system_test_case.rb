require_relative "../../../test/test_helper"
require "capybara/cuprite"


def iniciar_sesion(usuario, clave)
  visit root_url
  assert_content 'Pasos de Jesús'
  click_link 'Iniciar Sesión'
  assert_content 'Usuario'
  fill_in('Usuario', with: usuario)
  fill_in('Clave', with: clave)
  find_button('Iniciar Sesión').click
  assert_content 'Sesión iniciada.'
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  Capybara.javascript_driver = :cuprite
  Capybara.register_driver(:cuprite) do |app|
    Capybara::Cuprite::Driver.new(app, window_size: [1200, 800])
  end

  driven_by :cuprite
end
