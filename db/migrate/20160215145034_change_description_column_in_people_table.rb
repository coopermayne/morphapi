class ChangeDescriptionColumnInPeopleTable < ActiveRecord::Migration
  def up
    change_column :people, :description, :text
  end

  def down
    change_column :people, :description, :string
  end
end
