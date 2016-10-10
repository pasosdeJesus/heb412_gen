class AddAttachmentAdjuntoToHeb412GenDocs < ActiveRecord::Migration
  def self.up
    change_table :heb412_gen_doc do |t|
      t.attachment :adjunto
    end
  end

  def self.down
    remove_attachment :heb412_gen_doc, :adjunto
  end
end
