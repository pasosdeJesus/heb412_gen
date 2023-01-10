# frozen_string_literal: true

require "test_helper"

module Heb412Gen
  class DocTest < ActiveSupport::TestCase
    setup do
      Rails.application.config.x.formato_fecha = "yyyy-mm-dd"
    end

    test "valido" do
      d = Heb412Gen::Doc.create(PRUEBA_DOC)
      d.adjunto = File.new(Rails.root + "db/seeds.rb")

      assert_predicate d, :valid?
      d.save
      d.destroy
    end

    test "no valido" do
      d = Heb412Gen::Doc.new(PRUEBA_DOC)

      assert_not d.valid?
      d.destroy
    end
  end
end
