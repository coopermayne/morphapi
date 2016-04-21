class ChangeRankColumnInRoles < ActiveRecord::Migration
  def change
    change_column :roles, :rank, :integer, :default => 99999999
  end
end
