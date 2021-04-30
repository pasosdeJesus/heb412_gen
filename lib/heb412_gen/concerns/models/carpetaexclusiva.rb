module Heb412Gen
  module Concerns
    module Models
      module Carpetaexclusiva
        extend ActiveSupport::Concern
        include Sip::Modelo

        included do

          belongs_to :grupo, 
            class_name: 'Sip::Grupo',
            foreign_key: 'grupo_id', 
            validate: true

          validates :carpeta, presence: true, length: { maximum: 2047 }

        end # included

        class_methods do 
          def modelos_path
            'carpetasexclusivas_path'
          end
        end

      end
    end
  end
end
