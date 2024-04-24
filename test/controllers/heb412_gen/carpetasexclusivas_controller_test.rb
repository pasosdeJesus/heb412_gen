# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class CarpetasexclusivasControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers
    include Devise::Test::IntegrationHelpers
    # include Cocoon::ViewHelpers

    setup do
      if ENV["CONFIG_HOSTS"] != "www.example.com"
        raise "CONFIG_HOSTS debe ser www.example.com"
      end

      @current_usuario = ::Usuario.find(1)
      sign_in @current_usuario
      @grupo = Msip::Grupo.create(PRUEBA_GRUPO)

      assert_predicate @grupo, :valid?
      @carpetaexclusiva = Heb412Gen::Carpetaexclusiva.create!(
        PRUEBA_CARPETAEXCLUSIVA.merge(grupo_id: @grupo.id),
      )

      assert_predicate @carpetaexclusiva, :valid?
    end

    # Cada prueba que se ejecuta se hace en una transacción
    # que después de la prueba se revierte

    test "debe presentar listado" do
      get heb412_gen.carpetasexclusivas_path

      assert_response :success
      assert_template :index
    end

    test "debe presentar resumen de existente" do
      get heb412_gen.carpetaexclusiva_url(@carpetaexclusiva.id)

      assert_response :success
      assert_template :show
    end

    test "debe presentar formulario para nueva" do
      get heb412_gen.new_carpetaexclusiva_path

      assert_response :success
      assert_template :new
    end

    test "debe presentar formulario de edición" do
      get heb412_gen.edit_carpetaexclusiva_path(@carpetaexclusiva)

      assert_response :success
      assert_template :edit
    end

    test "debe crear nueva" do
      # Arreglamos indice
      # Msip::Carpetaexclusiva.connection.execute(<<-SQL.squish)
      #  SELECT setval('public.heb412_gen.carpetaexclusiva_id_seq', MAX(id))#{" "}
      #    FROM public.heb412_gen.carpetaexclusiva;
      # SQL
      assert_difference("Carpetaexclusiva.count") do
        post heb412_gen.carpetasexclusivas_path, params: {
          carpetaexclusiva: {
            id: nil,
            carpeta: "c2",
            grupo_id: @grupo.id,
          },
        }
      end

      assert_redirected_to heb412_gen.carpetaexclusiva_path(
        assigns(:carpetaexclusiva),
      )
    end

    test "debe actualizar existente" do
      patch heb412_gen.carpetaexclusiva_path(@carpetaexclusiva.id),
        params: {
          carpetaexclusiva: {
            id: @carpetaexclusiva.id,
            carpeta: "c3",
            grupo_id: @grupo.id,
          },
        }

      assert_redirected_to heb412_gen.carpetaexclusiva_path(assigns(:carpetaexclusiva))
    end

    test "debe eliminar" do
      assert_difference("Carpetaexclusiva.count", -1) do
        delete heb412_gen.carpetaexclusiva_path(Carpetaexclusiva
                                               .find(@carpetaexclusiva.id))
      end

      assert_redirected_to heb412_gen.carpetasexclusivas_path
    end
  end
end
