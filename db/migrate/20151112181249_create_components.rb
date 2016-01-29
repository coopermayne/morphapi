class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :content
      t.integer :rank

      t.timestamps null: false
    end
  end
end
