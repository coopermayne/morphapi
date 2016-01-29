class RemoveEducationFromPerson < ActiveRecord::Migration
  def change
    remove_column :people, :education, :string
  end
end
