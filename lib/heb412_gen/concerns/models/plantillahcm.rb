module Heb412Gen
  module Concerns
    module Models
      module Plantillahcm
        extend ActiveSupport::Concern
        include Msip::Modelo

        included do
          has_many :campoplantillahcm, 
            class_name: '::Heb412Gen::Campoplantillahcm',
            foreign_key: 'plantillahcm_id', validate: true, 
            dependent: :destroy
          accepts_nested_attributes_for :campoplantillahcm, 
            allow_destroy: true,
            reject_if: :all_blank

          has_and_belongs_to_many :formulario, 
            class_name: 'Mr519Gen::Formulario', 
            foreign_key: 'plantillahcm_id',
            association_foreign_key: 'formulario_id',
            join_table: 'heb412_gen_formulario_plantillahcm'

          validates :ruta, presence: true, length: { maximum: 2047 }
          validates :fuente, length: { maximum: 1023 }
          validates :licencia, length: { maximum: 1023 }
          validates :vista, presence: true, length: { maximum: 127}
          validates :nombremenu, presence: true, length: { maximum: 127}
          validates :filainicial, presence: true, numericality: { 
            only_integer: true, greater_than: 0}

          def modelos_path
            'plantillashcm_path'
          end

          def presenta_nombre
            nombremenu
          end

          def presenta(atr)
            case atr.to_sym
            when :vista
              Heb412Gen::Plantillahcm.human_attribute_name(self[atr].pluralize)
            else
              presenta_gen(atr)
            end
          end

        end # included

        class_methods do 
          def modelos_path
            'plantillashcm_path'
          end
        end

      end
    end
  end
end
