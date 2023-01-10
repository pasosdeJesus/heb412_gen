# frozen_string_literal: true

require "heb412_gen/concerns/models/campoplantillahcm"

module Heb412Gen
  class Campoplantillahcm < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Campoplantillahcm
  end
end
