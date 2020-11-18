# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Models
      module Plantillahcr
        extend ActiveSupport::Concern
        include Sip::Modelo

        included do
          has_and_belongs_to_many :formulario, 
            class_name: 'Mr519Gen::Formulario', 
            foreign_key: 'plantillahcr_id',
            association_foreign_key: 'formulario_id',
            join_table: 'heb412_gen_formulario_plantillahcr'

          has_many :campoplantillahcr, 
            class_name: '::Heb412Gen::Campoplantillahcr',
            foreign_key: 'plantillahcr_id', validate: true, 
            dependent: :destroy
          accepts_nested_attributes_for :campoplantillahcr, 
            allow_destroy: true,
            reject_if: :all_blank

          validates :ruta, presence: true, length: { maximum: 2047 }
          validates :fuente, length: { maximum: 1023 }
          validates :licencia, length: { maximum: 1023 }
          validates :vista, presence: true, length: { maximum: 127}
          validates :nombremenu, presence: true, length: { maximum: 127}

          def modelos_path
            'plantillashcr_path'
          end

          def presenta(atr)
            case atr.to_sym
            when :vista
              Heb412Gen::Plantillahcr.human_attribute_name(self[atr])
            else
              presenta_gen(atr)
            end
          end


        end # included

        class_methods do 
          def modelos_path
            'plantillashcr_path'
          end
        end

      end
    end
  end
end
