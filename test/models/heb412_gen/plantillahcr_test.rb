# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class PlantillahcrTest < ActiveSupport::TestCase
    setup do
      Rails.application.config.x.formato_fecha = "yyyy-mm-dd"
    end

    test "valido" do
      p = Heb412Gen::Plantillahcr.create(PRUEBA_PLANTILLAHCR)

      assert_predicate p, :valid?
      p.destroy
    end

    test "no valido" do
      p = Heb412Gen::Plantillahcr.new(PRUEBA_PLANTILLAHCR.merge(ruta: nil))

      assert_not p.valid?
      p.destroy
    end
  end
end
