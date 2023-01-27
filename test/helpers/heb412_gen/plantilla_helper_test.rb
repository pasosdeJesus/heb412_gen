# frozen_string_literal: true

require_relative "../../../app/helpers/heb412_gen/plantilla_helper"

module Heb412Gen
  class PlantillaHelperTest < ActionView::TestCase
    include Heb412Gen::PlantillaHelper

    test "sig_ant_col" do
      assert_equal "A", sigcol("")
      assert_equal "", antcol("A")
      assert_equal "B", sigcol("A")
      assert_equal "A", antcol("B")
      assert_equal "Z", sigcol("Y")
      assert_equal "Y", antcol("Z")
      assert_equal "AA", sigcol("Z")
      assert_equal "Z", antcol("AA")
      assert_equal "AB", sigcol("AA")
      assert_equal "AA", antcol("AB")
      assert_equal "AAAA", sigcol("ZZZ")
      assert_equal "ZZZ", antcol("AAAA")
    end

    test "compara_columnas" do
      assert_equal(-1, compara_columnas("A", "B"))
      assert_equal(1, compara_columnas("B", "A"))
      assert_equal(0, compara_columnas("A", "A"))
      assert_equal(-1, compara_columnas("AA", "AC"))
      assert_equal(1, compara_columnas("AC", "AA"))
      assert_equal(0, compara_columnas("AC", "AC"))
    end

    test "numero_a_columna" do
      assert_equal("", Heb412Gen::PlantillaHelper.numero_a_columna(0))
      assert_equal("", Heb412Gen::PlantillaHelper.numero_a_columna(-1))
      assert_equal("A", Heb412Gen::PlantillaHelper.numero_a_columna(1))
      assert_equal("Z", Heb412Gen::PlantillaHelper.numero_a_columna(26))
      assert_equal("AA", Heb412Gen::PlantillaHelper.numero_a_columna(27))
      assert_equal("AZ", Heb412Gen::PlantillaHelper.numero_a_columna(52))
      assert_equal("BA", Heb412Gen::PlantillaHelper.numero_a_columna(53))
      assert_equal("AAA", Heb412Gen::PlantillaHelper.numero_a_columna(703))
    end
  end
end
