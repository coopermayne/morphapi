class AddAffiliationToJournalists < ActiveRecord::Migration
  def change
    add_column :journalists, :affiliation, :string
  end
end
