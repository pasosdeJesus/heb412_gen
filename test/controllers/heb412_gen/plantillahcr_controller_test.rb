# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class PlantillahcrControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers
    include Devise::Test::IntegrationHelpers
    # include Cocoon::ViewHelpers

    setup do
      if ENV["CONFIG_HOSTS"] != "www.example.com"
        raise "CONFIG_HOSTS debe ser www.example.com"
      end

      @current_usuario = ::Usuario.find(1)
      sign_in @current_usuario
      @plantillahcr = Heb412Gen::Plantillahcr.create(PRUEBA_PLANTILLAHCR)

      assert_predicate @plantillahcr, :valid?
      @plantillahcr.save
    end

    # Cada prueba que se ejecuta se hace en una transacción
    # que después de la prueba se revierte

    test "debe presentar listado" do
      get heb412_gen.plantillashcr_path

      assert_response :success
      assert_template :index
    end

    test "debe presentar resumen de existente" do
      get heb412_gen.plantillahcr_url(@plantillahcr.id)

      assert_response :success
      assert_template :show
    end

    test "debe presentar formulario para nueva" do
      get heb412_gen.new_plantillahcr_path

      assert_response :success
      assert_template :new
    end

    test "debe presentar formulario de edición" do
      get heb412_gen.edit_plantillahcr_path(@plantillahcr)

      assert_response :success
      assert_template :edit
    end

    test "debe crear nueva" do
      skip # manejar primero plural de plantillahcr
      assert_difference("Plantillahcr.count") do
        post heb412_gen.plantillahcr_path, params: {
          plantillahcr: @plantillahcr.attributes.merge(
            ruta: "y",
          ),
        }
      end

      assert_response :redirect
    end

    test "debe actualizar existente" do
      patch heb412_gen.plantillahcr_path(@plantillahcr.id),
        params: {
          plantillahcr: @plantillahcr.attributes.merge("ruta": "Z"),
        }

      assert_redirected_to heb412_gen.plantillahcr_path(assigns(:plantillahcr))
    end

    test "debe eliminar" do
      assert_difference("Plantillahcr.count", -1) do
        delete heb412_gen.plantillahcr_path(Plantillahcr.find(@plantillahcr.id))
      end

      assert_response :redirect
    end
  end
end
