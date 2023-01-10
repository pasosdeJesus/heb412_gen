# frozen_string_literal: true

require "heb412_gen/concerns/models/plantillahcm"

module Heb412Gen
  class Plantillahcm < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Plantillahcm
  end
end
