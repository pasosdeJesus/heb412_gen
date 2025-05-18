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
      assert_equal File.join(
        Rails.configuration.relative_url_root, "sis/arch"
      ),
        heb412_gen.sisini_path("")
      assert_equal File.join(
        Rails.configuration.relative_url_root, "sis/nueva"
      ).to_s,
        heb412_gen.nueva_carpeta_path
      assert_equal File.join(
        Rails.configuration.relative_url_root, "sis/nuevo"
      ),
        heb412_gen.nuevo_archivo_path
      assert_equal File.join(
        Rails.configuration.relative_url_root, "sis/eliminararc"
      ),
        heb412_gen.eliminar_archivo_path
      assert_equal File.join(
        Rails.configuration.relative_url_root, "sis/eliminardir"
      ),
        heb412_gen.eliminar_directorio_path
    end

    test "listado de archivos" do
      get heb412_gen.sisarch_path("arch/")

      assert_response :success
      assert_template :index
    end

    test "crear carpeta" do
      ruta = Rails.application.config.x.heb412_ruta.join("z")
      FileUtils.rm_rf(ruta)
      post heb412_gen.nueva_carpeta_path,
        params: { nueva: { ruta: "arch/", nombre: "z" } },
        headers: { "HTTP_ACCEPT" => "text/javascript" }

      assert Dir.exist?(ruta)
      FileUtils.rm_rf(ruta)
    end

    test "crear archivo" do
      arch = fixture_file_upload("ico.png", "image/png")
      puts arch.original_filename
      ruta = Rails.application.config.x.heb412_ruta
        .join(arch.original_filename)
      FileUtils.rm_rf(ruta)
      post heb412_gen.nuevo_archivo_path,
        params: {
          nuevo: {
            ruta: "arch/",
            archivo: arch,
          },
        },
        headers: { "HTTP_ACCEPT" => "text/javascript" }

      assert_path_exists(ruta)
      FileUtils.rm_rf(ruta)
    end

    test "actualizar leeme" do
      ruta = Rails.application.config.x.heb412_ruta.join("LEEME.md")
      FileUtils.rm_rf(ruta)
      post heb412_gen.actleeme_path,
        params: {
          actleeme: {
            ruta: "arch/",
            leeme: "123",
          },
        }

      assert_response :redirect
      assert_path_exists(ruta)
      assert_equal("123", File.read(ruta))
      FileUtils.rm_rf(ruta)
    end

    test "eliminar archivo" do
      ruta = Rails.application.config.x.heb412_ruta.join("LEEME.md")
      FileUtils.touch(ruta)
      post heb412_gen.eliminar_archivo_path,
        params: { ruta: "arch/", arc: "LEEME.md" },
        headers: { "HTTP_ACCEPT" => "text/javascript" }

      refute_path_exists(ruta)
    end

    test "eliminar directorio" do
      ruta = Rails.application.config.x.heb412_ruta.join("z")
      FileUtils.mkdir_p(ruta)
      post heb412_gen.eliminar_directorio_path,
        params: { ruta: "arch/", dir: "z" },
        headers: { "HTTP_ACCEPT" => "text/javascript" }

      refute_path_exists(ruta)
    end
  end
end
