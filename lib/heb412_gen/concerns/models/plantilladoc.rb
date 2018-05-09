# encoding: UTF-8
module Heb412Gen
  module Concerns
    module Models
      module Plantilladoc
        extend ActiveSupport::Concern
        include Sip::Modelo

        included do

          validates :ruta, presence: true, length: { maximum: 2047 }
          validates :fuente, length: { maximum: 1023 }
          validates :licencia, length: { maximum: 1023 }
          validates :vista, presence: true, length: { maximum: 127}
          validates :nombremenu, presence: true, length: { maximum: 127}

          def presenta_nombre
            "#{id}: #{vista}, #{nombremenu}"
          end

        end

      end
    end
  end
end
