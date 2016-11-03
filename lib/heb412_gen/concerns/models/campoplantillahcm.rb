# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Models
      module Campoplantillahcm
        extend ActiveSupport::Concern

        included do

          belongs_to :plantillahcm, class_name: '::Heb412Gen::Plantillahcm',
            foreign_key: 'plantillahcm_id'

          validates :nombrecampo, 
            uniqueness: { scope: :plantillahcm_id, 
                          message: "no puede haber campos repetidos"
          } 

          validates :columna, 
            uniqueness: { scope: :plantillahcm_id, 
                          message: "no puede haber columnas repetidas"
          } 

        end # included

      end
    end
  end
end
