class AddFirstNameToJournalists < ActiveRecord::Migration
  def change
    add_column :journalists, :first_name, :string
  end
end
