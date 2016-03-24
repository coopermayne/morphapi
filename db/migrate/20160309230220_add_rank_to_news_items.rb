class AddRankToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :rank, :integer
  end
end
