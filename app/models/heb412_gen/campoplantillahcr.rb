# frozen_string_literal: true

require "heb412_gen/concerns/models/campoplantillahcr"

module Heb412Gen
  class Campoplantillahcr < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Campoplantillahcr
  end
end
