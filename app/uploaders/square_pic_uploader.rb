class SquarePicUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version(:r1x1_192x192) { process :resize_to_fill => [192, 192] }

  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    # "/images/#{version_name}.png"
    '/images/fungiorbis192.png'
  end
end
