# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class CampohcTest < ActiveSupport::TestCase
    setup do
      Rails.application.config.x.formato_fecha = "yyyy-mm-dd"
    end

    test "valido" do
      d = Heb412Gen::Doc.new(PRUEBA_DOC)
      d.adjunto = File.new(Rails.root + "db/seeds.rb")

      assert_predicate d, :valid?
      d.save
      c = Heb412Gen::Campohc.new(PRUEBA_CAMPOHC)
      c.doc = d

      assert_predicate c, :valid?
      c.save
      c.destroy
      d.destroy
    end

    test "no valido" do
      c = Heb412Gen::Campohc.new(PRUEBA_CAMPOHC)

      assert_not c.valid?
      c.destroy
    end
  end
end
