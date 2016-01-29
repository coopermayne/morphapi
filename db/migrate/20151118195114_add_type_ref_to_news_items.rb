class AddTypeRefToNewsItems < ActiveRecord::Migration
  def change
    add_reference :news_items, :news_type, index: true
  end
end
