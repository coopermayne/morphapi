class CreateComponentTypes < ActiveRecord::Migration
  def change
    create_table :component_types do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
