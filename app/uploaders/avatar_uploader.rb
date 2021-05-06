# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # depreciated include CarrierWave::MimeTypes

  process :set_content_type

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
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
    new_file.content_type.start_with? 'image'
  end

end
