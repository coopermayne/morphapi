class AddPrimaryImageToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :primary_id, :integer
  end
end
