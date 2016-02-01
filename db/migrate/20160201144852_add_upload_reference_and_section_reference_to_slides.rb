class AddUploadReferenceAndSectionReferenceToSlides < ActiveRecord::Migration
  def change
    add_reference :slides, :upload, index: true
    add_reference :slides, :section, index: true
  end
end
