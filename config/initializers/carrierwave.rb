CarrierWave.configure do |config|
  config.permissions = 0666
  config.directory_permissions = 0755
  config.storage = :file

  config.enable_processing = ! Rails.env.test?
  Dir["#{Rails.root}/app/uploaders/*.rb"].each { |file| require file }
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        if Rails.env.test?
          "#{Rails.root}/spec/support/uploads/tmp"
        else
          "#{Rails.root}/public/uploads/tmp"
        end
      end

      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end

      def extension_white_list
        %w(jpg png)
      end
    end
  end
end