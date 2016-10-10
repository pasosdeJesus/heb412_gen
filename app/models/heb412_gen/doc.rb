# encoding: UTF-8

require 'heb412_gen/concerns/models/doc'

module Heb412Gen
  class Doc < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Doc
  end
end
