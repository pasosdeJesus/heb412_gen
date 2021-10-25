require 'heb412_gen/concerns/models/formulario'

module Mr519Gen
  class Formulario < ActiveRecord::Base
    include Heb412Gen::Concerns::Models::Formulario
  end
end
