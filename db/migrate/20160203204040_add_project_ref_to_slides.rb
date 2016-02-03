class AddProjectRefToSlides < ActiveRecord::Migration
  def change
    add_reference :slides, :project, index: true, foreign_key: true
  end
end
