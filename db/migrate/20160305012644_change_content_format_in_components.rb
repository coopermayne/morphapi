class ChangeContentFormatInComponents < ActiveRecord::Migration
	def up
		change_column :components, :content, :text
	end

	def down
		change_column :components, :content, :string
	end
end
