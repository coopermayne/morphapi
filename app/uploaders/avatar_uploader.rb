# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.id}"
  end

  process :resize_to_limit => [1600, 1200], :if => :image?

  version :mobile, :if => :image? do
    process :resize_to_limit => [500, 10000]
  end

  version :thumb, :if => :image? do
    process :resize_to_limit => [10000, 200]
  end

  def image?(new_file)
    ['jpg', 'jpeg', 'png'].include?(new_file.extension.downcase)
  end

end
