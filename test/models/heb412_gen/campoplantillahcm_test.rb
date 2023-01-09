require 'test_helper'

module Heb412Gen
  class CampoplantillahcmTest < ActiveSupport::TestCase
    setup do
      Rails.application.config.x.formato_fecha = 'yyyy-mm-dd'
      @plantillahcm = Heb412Gen::Plantillahcm.create PRUEBA_PLANTILLAHCM
      assert @plantillahcm.valid?
    end

    test "valido" do
      c = Heb412Gen::Campoplantillahcm.new PRUEBA_CAMPOPLANTILLAHCM
      c.plantillahcm = @plantillahcm
      assert c.valid?
      c.save
      c.destroy
    end

    test "no valido" do
      c = Heb412Gen::Campoplantillahcm.new PRUEBA_CAMPOPLANTILLAHCM
      assert_not c.valid?
      c.destroy
    end

  end
end
