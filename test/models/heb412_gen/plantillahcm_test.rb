
require 'test_helper'
require_relative '../../../app/helpers/heb412_gen/plantilla_helper'

module Heb412Gen
  class PlantillahcmTest < ActionView::TestCase

    include Heb412Gen::PlantillaHelper

    test 'inserta_elimina_columna' do
      p = Heb412Gen::Plantillahcm.create!(
        ruta: 'xyz',
        nombremenu: 'loco',
        filainicial: 5,
        vista: 'gorda'
      )
      nc = Heb412Gen::Campoplantillahcm.create!(
        nombrecampo: 'd',
        columna: 'A',
        plantillahcm_id: p.id
      )
      ncid = nc.id

      inserta_columna(p.id, ncid + 1, 'A', 'c')
      inserta_columna(p.id, ncid + 2, 'A', 'b')
      inserta_columna(p.id, ncid + 3, 'A', 'a')
      assert_equal 4, Heb412Gen::Campoplantillahcm.
        where(plantillahcm_id: p.id).count
      assert_equal 'D', Heb412Gen::Campoplantillahcm.find(ncid).columna
      assert_equal 'C', Heb412Gen::Campoplantillahcm.find(ncid + 1).columna
      assert_equal 'B', Heb412Gen::Campoplantillahcm.find(ncid + 2).columna
      assert_equal 'A', Heb412Gen::Campoplantillahcm.find(ncid + 3).columna

      elimina_columna(p.id, ncid+3)
      assert_equal 'A', Heb412Gen::Campoplantillahcm.find(ncid + 2).columna
      elimina_columna(p.id, ncid+2)
      assert_equal 'A', Heb412Gen::Campoplantillahcm.find(ncid + 1).columna
      elimina_columna(p.id, ncid+1)
      assert_equal 'A', Heb412Gen::Campoplantillahcm.find(ncid).columna
      elimina_columna(p.id, ncid)
      assert_equal 0, Heb412Gen::Campoplantillahcm.
        where(plantillahcm_id: p.id).count
    end

  end
end
