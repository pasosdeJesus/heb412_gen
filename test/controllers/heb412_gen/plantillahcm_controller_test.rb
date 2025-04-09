# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class PlantillahcmControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers
    include Devise::Test::IntegrationHelpers
    # include Cocoon::ViewHelpers

    setup do
      if ENV["CONFIG_HOSTS"] != "www.example.com"
        raise "CONFIG_HOSTS debe ser www.example.com"
      end

      Rails.application.try(:reload_routes_unless_loaded)
      @current_usuario = ::Usuario.find(1)
      sign_in @current_usuario
      @plantillahcm = Heb412Gen::Plantillahcm.create(PRUEBA_PLANTILLAHCM)

      assert_predicate @plantillahcm, :valid?
      @plantillahcm.save
    end

    # Cada prueba que se ejecuta se hace en una transacción
    # que después de la prueba se revierte

    test "debe presentar listado" do
      get heb412_gen.plantillashcm_path

      assert_response :success
      assert_template :index
    end

    test "debe presentar resumen de existente" do
      get heb412_gen.plantillahcm_url(@plantillahcm.id)

      assert_response :success
      assert_template :show
    end

    test "debe presentar formulario para nueva" do
      get heb412_gen.new_plantillahcm_path

      assert_response :success
      assert_template :new
    end

    test "debe presentar formulario de edición" do
      get heb412_gen.edit_plantillahcm_path(@plantillahcm)

      assert_response :success
      assert_template :edit
    end

    test "debe crear nueva" do
      skip # manejar primero plural de plantillahcm
      assert_difference("Plantillahcm.count") do
        post heb412_gen.plantillahcm_path, params: {
          plantillahcm: @plantillahcm.attributes.merge(
            ruta: "y",
          ),
        }
      end

      assert_response :redirect
    end

    test "debe actualizar existente" do
      patch heb412_gen.plantillahcm_path(@plantillahcm.id),
        params: {
          plantillahcm: @plantillahcm.attributes.merge("ruta": "Z"),
        }

      assert_redirected_to heb412_gen.plantillahcm_path(assigns(:plantillahcm))
    end

    test "debe eliminar" do
      assert_difference("Plantillahcm.count", -1) do
        delete heb412_gen.plantillahcm_path(Plantillahcm.find(@plantillahcm.id))
      end

      assert_response :redirect
    end
  end
end
