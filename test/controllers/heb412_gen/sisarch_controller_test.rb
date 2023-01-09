# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class SisarchControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers
    include Devise::Test::IntegrationHelpers
    # include Cocoon::ViewHelpers

    setup do
      if ENV["CONFIG_HOSTS"] != "www.example.com"
        raise "CONFIG_HOSTS debe ser www.example.com"
      end

      @current_usuario = ::Usuario.find(1)
      sign_in @current_usuario
    end

    # Cada prueba que se ejecuta se hace en una transacción
    # que después de la prueba se revierte

    test "rutas" do
      assert_equal '/heb412/sis/arch', heb412_gen.sisini_path('')
      assert_equal '/heb412/sis/nueva', heb412_gen.nueva_carpeta_path
      assert_equal '/heb412/sis/nuevo', heb412_gen.nuevo_archivo_path
      assert_equal '/heb412/sis/eliminararc', heb412_gen.eliminar_archivo_path
      assert_equal '/heb412/sis/eliminardir', 
        heb412_gen.eliminar_directorio_path
    end

    test "listado de archivos" do
      get heb412_gen.sisarch_path('arch/')

      assert_response :success
      assert_template :index
    end

    test "crear carpeta" do
      ruta = Rails.application.config.x.heb412_ruta.join("z")
      FileUtils.rm_rf ruta
      post heb412_gen.nueva_carpeta_path,
        params: {nueva: {ruta: 'arch/', nombre: 'z'}},
        headers: { 'HTTP_ACCEPT' => 'text/javascript' }
      assert Dir.exist? ruta
      FileUtils.rm_rf ruta
    end

    test "crear archivo" do
      arch = fixture_file_upload 'ico.png', 'image/png'
      puts arch.original_filename
      ruta = Rails.application.config.x.heb412_ruta.
        join(arch.original_filename)
      FileUtils.rm_rf ruta
      post heb412_gen.nuevo_archivo_path,
        params: {nuevo: {
          ruta: 'arch/',
          archivo: arch
        }},
        headers: { 'HTTP_ACCEPT' => 'text/javascript' }
      assert File.exist? ruta
      FileUtils.rm_rf ruta
    end

    test "actualizar leeme" do
      ruta = Rails.application.config.x.heb412_ruta.join('LEEME.md') 
      FileUtils.rm_rf ruta
      post heb412_gen.actleeme_path,
        params: {actleeme: {
          ruta: 'arch/',
          leeme: '123'
        }}
      assert_response :redirect
      assert File.exist? ruta
      assert File.read(ruta) == '123'
      FileUtils.rm_rf ruta
    end

    test "eliminar archivo" do
      ruta = Rails.application.config.x.heb412_ruta.join('LEEME.md') 
      FileUtils.touch ruta
      post heb412_gen.eliminar_archivo_path,
        params: {ruta: 'arch/', arc: 'LEEME.md'},
        headers: { 'HTTP_ACCEPT' => 'text/javascript' }
      assert !File.exist?(ruta)
    end

    test "eliminar directorio" do
      ruta = Rails.application.config.x.heb412_ruta.join('z') 
      FileUtils.mkdir_p ruta
      post heb412_gen.eliminar_directorio_path,
        params: {ruta: 'arch/', dir: 'z'},
        headers: { 'HTTP_ACCEPT' => 'text/javascript' }
      assert !File.exist?(ruta)
    end

  end
end
