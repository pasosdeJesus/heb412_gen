# frozen_string_literal: true

require "test_helper"

class PlantillasdocControllerTest < ActionController::TestCase
  setup do
    skip
    @plantilladoc = Plantilladoc(:one)
  end

  test "should get index" do
    skip
    get :index

    assert_response :success
    assert_not_nil assigns(:plantilladoc)
  end

  test "should get new" do
    skip
    get :new

    assert_response :success
  end

  test "should create plantilladoc" do
    skip
    assert_difference("Plantilladoc.count") do
      post :create, params: {
        plantilladoc: {
          created_at: @plantilladoc.created_at,
          fechacreacion: @plantilladoc.fechacreacion,
          fechadeshabilitacion: @plantilladoc.fechadeshabilitacion,
          nombre: @plantilladoc.nombre,
          observaciones: @plantilladoc.observaciones,
          updated_at: @plantilladoc.updated_at,
        },
      }
    end

    assert_redirected_to plantilladoc_path(assigns(:plantilladoc))
  end

  test "should show plantilladoc" do
    skip
    get :show, params: { id: @plantilladoc }

    assert_response :success
  end

  test "should get edit" do
    skip
    get :edit, params: { id: @plantilladoc }

    assert_response :success
  end

  test "should update plantilladoc" do
    skip
    patch :update, params: {
      id: @plantilladoc,
      plantilladoc: {
        created_at: @plantilladoc.created_at,
        fechacreacion: @plantilladoc.fechacreacion,
        fechadeshabilitacion: @plantilladoc.fechadeshabilitacion,
        nombre: @plantilladoc.nombre,
        observaciones: @plantilladoc.observaciones,
        updated_at: @plantilladoc.updated_at,
      },
    }

    assert_redirected_to plantilladoc_path(assigns(:plantilladoc))
  end

  test "should destroy plantilladoc" do
    skip
    assert_difference("Plantilladoc.count", -1) do
      delete :destroy, params: { id: @plantilladoc }
    end

    assert_redirected_to plantilladoces_path
  end
end
