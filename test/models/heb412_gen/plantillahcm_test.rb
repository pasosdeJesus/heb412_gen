# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class PlantillahcmTest < ActiveSupport::TestCase
    setup do
      Rails.application.config.x.formato_fecha = "yyyy-mm-dd"
    end

    test "valido" do
      p = Heb412Gen::Plantillahcm.create(PRUEBA_PLANTILLAHCM)

      assert_predicate p, :valid?
      p.destroy
    end

    test "no valido" do
      p = Heb412Gen::Plantillahcm.new(PRUEBA_PLANTILLAHCM.merge(ruta: nil))

      assert_not p.valid?
      p.destroy
    end
  end
end
