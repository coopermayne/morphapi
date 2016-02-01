class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.integer :rank
      t.boolean :visible
      t.boolean :is_image

      t.timestamps null: false
    end
  end
end
