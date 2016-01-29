class CreateProjectTypes < ActiveRecord::Migration
  def change
    create_table :project_types do |t|
      t.column :title, :string
      t.column :rank, :integer
    end
  end
end
