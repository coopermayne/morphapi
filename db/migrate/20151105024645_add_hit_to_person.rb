class AddHitToPerson < ActiveRecord::Migration
  def change
    add_column :people, :hit, :integer
  end
end
