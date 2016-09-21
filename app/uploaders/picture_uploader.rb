class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded; limit dimensions and convert to png format:
  process :mogrify => [{:resolution => '1920x1920'}]

  # Create square version
  version :square do
    process :resize_to_fill => [600, 600]
  end

  # White list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png bmp tif tiff)
  end

  # Override the filename of the uploaded files w/ uuid:
  def filename
    "#{secure_token}.png" if original_filename.present?
  end

  private

  def mogrify(options = {})
    manipulate! do |img|
      img.format("png") do |c|
        c.fuzz        "3%"
        c.trim
        c.rotate      "#{options[:rotate]}" if options.has_key?(:rotate)
        c.resize      "#{options[:resolution]}>" if options.has_key?(:resolution)
        c.resize      "#{options[:resolution]}<" if options.has_key?(:resolution)
        c.profile.+   "!xmp,*"
        c.profile     "#{Rails.root}/lib/color_profiles/sRGB_v4_ICC_preference_displayclass.icc"
        c.colorspace  "sRGB"
      end
      img
    end
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
