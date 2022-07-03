module CoreExtensions
  module ActiveStorage
    module Blob
      module ServiceUrl
        def url(*)
          if [:local, :test].include?(Rails.configuration.active_storage.service)
            host = "http://#{Rails.application.routes.default_url_options[:host]}"
            ::ActiveStorage::Current.set(host: host) { super }
          else
            super
          end
        end
      end
    end
  end
end

# The service_url method does appear to work with the active storage "disk" service
# This monkey patch is applied in development and test only
if %w[development test].include?(Rails.env)
  ActiveSupport.on_load(:active_storage_blob) do
    prepend(CoreExtensions::ActiveStorage::Blob::ServiceUrl)
  end
end