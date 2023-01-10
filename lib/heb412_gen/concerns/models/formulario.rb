# frozen_string_literal: true

require "mr519_gen/concerns/models/formulario"

module Heb412Gen
  module Concerns
    module Models
      module Formulario
        extend ActiveSupport::Concern

        included do
          include Mr519Gen::Concerns::Models::Formulario

          has_and_belongs_to_many :plantillahcr,
            class_name: "Heb412Gen::Plantillahcr",
            foreign_key: "formulario_id",
            association_foreign_key: "plantillahcr_id",
            join_table: "heb412_gen_formulario_plantillahcr"
        end # included
      end
    end
  end
end
