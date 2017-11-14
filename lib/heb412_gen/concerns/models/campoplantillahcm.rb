# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Models
      module Campoplantillahcm
        extend ActiveSupport::Concern

        included do

          belongs_to :plantillahcm, class_name: '::Heb412Gen::Plantillahcm',
            foreign_key: 'plantillahcm_id', validate: true

          validates :nombrecampo, 
            uniqueness: { scope: :plantillahcm_id, 
                          message: "no puede haber campos repetidos" },
                          presence: true,
                          allow_blank: false,
                          length: { minimum: 1}

          validates :columna, 
            uniqueness: { scope: :plantillahcm_id, 
                          message: "no puede haber columnas repetidas" },
                          presence: true,
                          allow_blank: false,
                          length: { minimum: 1}
          

        end # included

      end
    end
  end
end
