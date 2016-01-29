class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :overview
      t.text :description
      t.text :program
      t.string :client
      t.integer :size
      t.decimal :site_area
      t.decimal :lat
      t.decimal :lon
      t.string :street_address
      t.integer :zip
      t.date :design_sdate
      t.date :design_edate
      t.date :constr_sdate
      t.date :constr_edate
      t.date :open_sdate
      t.date :close_edate

      t.timestamps null: false
    end
  end
end
