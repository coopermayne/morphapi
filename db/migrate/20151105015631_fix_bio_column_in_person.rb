class FixBioColumnInPerson < ActiveRecord::Migration
  def change
    rename_column :people, :bio, :description
  end
end
