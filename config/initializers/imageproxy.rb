Rails.application.config.x.imageproxy.host = ENV["IMAGEPROXY_HOST"] || Rails.application.credentials.imageproxy&.fetch(:host)
Rails.application.config.x.imageproxy.secret_key = ENV["IMAGEPROXY_KEY"] || Rails.application.credentials.imageproxy&.fetch(:secret_key)
