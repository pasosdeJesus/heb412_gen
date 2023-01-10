# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class CarpetaexclusivaTest < ActiveSupport::TestCase
    setup do
      Rails.application.config.x.formato_fecha = "yyyy-mm-dd"
    end

    test "valido" do
      g = Msip::Grupo.create(PRUEBA_GRUPO)
      c = Heb412Gen::Carpetaexclusiva.create(PRUEBA_CARPETAEXCLUSIVA.merge(
        grupo_id: g.id,
      ))

      assert_predicate c, :valid?
      c.destroy
    end

    test "no valido" do
      c = Heb412Gen::Carpetaexclusiva.new(PRUEBA_CARPETAEXCLUSIVA)

      assert_not c.valid?
      c.destroy
    end
  end
end
