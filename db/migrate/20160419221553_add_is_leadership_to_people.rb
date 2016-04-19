class AddIsLeadershipToPeople < ActiveRecord::Migration
  def change
    add_column :people, :is_leadership, :boolean, default: false
  end
end
