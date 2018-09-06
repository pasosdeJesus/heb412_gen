# encoding: UTF-8

require 'heb412_gen/concerns/models/plantillahcr'

module Heb412Gen
  class Plantillahcr < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Plantillahcr
  end
end
