class AddLastNameToJournalists < ActiveRecord::Migration
  def change
    add_column :journalists, :last_name, :string
  end
end
