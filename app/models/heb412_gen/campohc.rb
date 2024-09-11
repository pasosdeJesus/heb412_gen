# frozen_string_literal: true

require "heb412_gen/concerns/models/campohc"

module Heb412Gen
  # Campo en una plantilla de documento
  class Campohc < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Campohc
  end
end
