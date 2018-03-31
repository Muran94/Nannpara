class ProfileImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process resize_to_fill: [400, 400, ::Magick::CenterGravity] unless Rails.env.test?

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  process convert: 'jpg'

  version :thumb do
    process resize_to_fill: [40, 40, ::Magick::CenterGravity]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
  end
end
