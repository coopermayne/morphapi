class CreateNewsTypes < ActiveRecord::Migration
  def change
    create_table :news_types do |t|
      t.string :title
      t.integer :rank
      t.boolean :is_lecture

      t.timestamps null: false
    end
  end
end
