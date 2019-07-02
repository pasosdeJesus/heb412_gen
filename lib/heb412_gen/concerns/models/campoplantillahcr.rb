# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Models
      module Campoplantillahcr
        extend ActiveSupport::Concern

        included do

          belongs_to :plantillahcr, class_name: '::Heb412Gen::Plantillahcr',
            foreign_key: 'plantillahcr_id', validate: true

          validates :nombrecampo, 
            presence: true,
            allow_blank: false,
            length: { minimum: 1}

          validates :columna, 
            uniqueness: { 
            scope: [:plantillahcr_id, :fila], 
            message: "no puede haber celdas repetidas" },
            presence: true,
            allow_blank: false,
            length: { minimum: 1}

          validates :fila, 
            presence: true,
            allow_blank: false,
            numericality: { greater_than: 0}

          def presenta_nombre
            nombrecampo
          end         

        end # included

      end
    end
  end
end
