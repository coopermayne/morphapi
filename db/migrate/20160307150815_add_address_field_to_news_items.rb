class AddAddressFieldToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :address, :string
  end
end
