class Upload < ActiveRecord::Base
  mount_uploader :name, AvatarUploader
  belongs_to :file_type
  belongs_to :credit

  belongs_to :uploadable, polymorphic: true
end
