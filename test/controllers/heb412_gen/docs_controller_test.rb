# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class DocsControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers
    include Devise::Test::IntegrationHelpers
    # include Cocoon::ViewHelpers

    setup do
      if ENV["CONFIG_HOSTS"] != "www.example.com"
        raise "CONFIG_HOSTS debe ser www.example.com"
      end

      @current_usuario = ::Usuario.find(1)
      sign_in @current_usuario
      @doc =  Heb412Gen::Doc.create PRUEBA_DOC
      @doc.adjunto = File.new(Rails.root + "db/seeds.rb")
      assert @doc.valid?
      @doc.save
    end

    # Cada prueba que se ejecuta se hace en una transacción
    # que después de la prueba se revierte

    test "debe presentar listado" do
      get heb412_gen.docs_path

      assert_response :success
      assert_template :index
    end

    test "debe presentar resumen de existente" do
      get heb412_gen.doc_url(@doc.id)

      assert_response :success
      assert_template :show
    end

    test "debe presentar formulario para nueva" do
      get heb412_gen.new_doc_path

      assert_response :success
      assert_template :new
    end

    test "debe presentar formulario de edición" do
      get heb412_gen.edit_doc_path(@doc)

      assert_response :success
      assert_template :edit
    end

    test "debe crear nueva" do
      # Arreglamos indice
      #Msip::Doc.connection.execute(<<-SQL.squish)
      #  SELECT setval('public.heb412_gen.doc_id_seq', MAX(id))#{" "}
      #    FROM public.heb412_gen.doc;
      #SQL
      arch = fixture_file_upload 'ico.png'
      assert_difference("Doc.count") do
        post heb412_gen.docs_path, params: {
          doc: @doc.attributes.merge(
            id: nil, 
            nombre: 'X',
            adjunto: arch
          )
        }
      end

      assert_response :redirect
    end

    test "debe actualizar existente" do
      patch heb412_gen.doc_path(@doc.id),
        params: {
          doc: @doc.attributes.merge("nombre": 'Z')
        }

      assert_redirected_to heb412_gen.doc_path(assigns(:doc))
    end

    test "debe eliminar" do
      assert_difference("Doc.count", -1) do
        delete heb412_gen.doc_path(Doc.find(@doc.id))
      end

      assert_redirected_to heb412_gen.docs_path
    end
  end
end
