Rails.application.config.x.imageproxy.host = ENV["IMAGEPROXY_HOST"] || Rails.application.credentials.imageproxy.values_at(:host)
Rails.application.config.x.imageproxy.secret_key = ENV["IMAGEPROXY_KEY"] || Rails.application.credentials.imageproxy.values_at(:secret_key)
