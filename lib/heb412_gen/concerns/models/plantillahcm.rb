# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Models
      module Plantillahcm
        extend ActiveSupport::Concern
        include Sip::Modelo

        included do
          has_many :campoplantillahcm, 
            class_name: '::Heb412Gen::Campoplantillahcm',
            foreign_key: 'plantillahcm_id', validate: true, 
            dependent: :destroy
          accepts_nested_attributes_for :campoplantillahcm, 
            allow_destroy: true,
            reject_if: :all_blank

          validates :ruta, presence: true, length: { maximum: 2047 }
          validates :fuente, length: { maximum: 1023 }
          validates :licencia, length: { maximum: 1023 }
          validates :vista, presence: true, length: { maximum: 127}
          validates :nombremenu, presence: true, length: { maximum: 127}
          validates :filainicial, presence: true, numericality: { 
            only_integer: true, greater_than: 0}

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
