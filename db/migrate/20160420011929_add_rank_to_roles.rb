class AddRankToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :rank, :integer
  end
end
