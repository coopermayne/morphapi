class AddProjectToGalleries < ActiveRecord::Migration
  def change
    add_reference :galleries, :project, index: true, foreign_key: true
  end
end
