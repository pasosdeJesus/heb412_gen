# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class CampoplantillahcrTest < ActiveSupport::TestCase
    setup do
      Rails.application.config.x.formato_fecha = "yyyy-mm-dd"
      @plantillahcr = Heb412Gen::Plantillahcr.create(PRUEBA_PLANTILLAHCR)

      assert_predicate @plantillahcr, :valid?
    end

    test "valido" do
      c = Heb412Gen::Campoplantillahcr.new(PRUEBA_CAMPOPLANTILLAHCR)
      c.plantillahcr = @plantillahcr

      assert_predicate c, :valid?
      c.save
      c.destroy
    end

    test "no valido" do
      c = Heb412Gen::Campoplantillahcr.new(PRUEBA_CAMPOPLANTILLAHCR)

      assert_not c.valid?
      c.destroy
    end
  end
end
