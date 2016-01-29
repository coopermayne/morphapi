class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :title
      t.text :description
      t.text :overview
      t.integer :hit
      t.integer :year

      t.timestamps null: false
    end
  end
end
