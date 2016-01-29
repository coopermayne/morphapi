class Upload < ActiveRecord::Base
  mount_uploader :name, AvatarUploader
  belongs_to :file_type
  belongs_to :credit

  belongs_to :project
  belongs_to :news_item
  belongs_to :person
end
