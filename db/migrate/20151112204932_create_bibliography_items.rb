class CreateBibliographyItems < ActiveRecord::Migration
  def change
    create_table :bibliography_items do |t|
      t.string :title
      t.text :description
      t.text :overview
      t.integer :hit
      t.string :author
      t.string :article_name
      t.string :book_title
      t.string :subtitle
      t.string :publication
      t.string :publisher
      t.string :date
      t.date :pub_date
      t.string :pages

      t.timestamps null: false
    end
  end
end
