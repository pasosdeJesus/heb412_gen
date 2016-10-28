# encoding: UTF-8

require 'heb412_gen/concerns/models/campohc'

module Heb412Gen
  class Campohc < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Campohc
  end
end
