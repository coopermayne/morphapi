class AddSectionRefToProjectTypes < ActiveRecord::Migration
  def change
    add_reference :project_types, :section, index: true, foreign_key: true
  end
end
