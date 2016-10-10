# encoding: UTF-8

module Heb412Gen
  module Concerns
    module Models
      module Doc
        extend ActiveSupport::Concern

        included do

          has_attached_file :adjunto, :path => :ruta_doc

          def ruta_doc
            File.join(Sip.ruta_anexos, created_at.year.to_s,
            created_at.month.to_s.rjust(2, '0'),
            created_at.day.to_s.rjust(2, '0'),
            "/#{id}_#{adjunto_file_name}")
          end

          validates_attachment_content_type :adjunto, 
            :content_type => ['text/plain', /.*/]
          validates_attachment_presence :adjunto
          validates :adjunto_file_name, length: { maximum: 255 }
          validates :adjunto_content_type, length: { maximum: 255 }
          validates :descripcion, length: { maximum: 1500 } 

        end # included

      end
    end
  end
end
