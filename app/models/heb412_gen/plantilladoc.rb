# frozen_string_literal: true

require "heb412_gen/concerns/models/plantilladoc"

module Heb412Gen
  class Plantilladoc < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Plantilladoc
  end
end
