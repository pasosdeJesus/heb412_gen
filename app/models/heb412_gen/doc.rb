# frozen_string_literal: true

require "heb412_gen/concerns/models/doc"

module Heb412Gen
  # Plantilla de documento
  class Doc < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Doc
  end
end
