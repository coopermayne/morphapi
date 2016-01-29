class CreateNewsItems < ActiveRecord::Migration
  def change
    create_table :news_items do |t|
      t.string :title
      t.text :description
      t.text :overview
      t.integer :hit
      t.string :place
      t.string :street_address
      t.string :country
      t.string :city
      t.string :state
      t.integer :zip
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
