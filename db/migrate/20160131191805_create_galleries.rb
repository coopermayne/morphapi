class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :title
      t.integer :rank
      t.boolean :visible

      t.timestamps null: false
    end
  end
end
