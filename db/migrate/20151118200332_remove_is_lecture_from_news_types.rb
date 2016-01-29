class RemoveIsLectureFromNewsTypes < ActiveRecord::Migration
  def change
    remove_column :news_types, :is_lecture, :boolean
  end
end
