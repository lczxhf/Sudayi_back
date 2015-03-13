  require 'carrierwave/mongoid'
class ImageItemUpload < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model._id}"
  end

  version :thumb do
    process :resize_to_limit => [200, 200]
  end
end