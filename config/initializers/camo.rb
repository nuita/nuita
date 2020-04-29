if Rails.env.production?
  ENV["CAMO_HOST"] = Rails.application.credentials.camo[:host]
  ENV["CAMO_KEY"] = Rails.application.credentials.camo[:key]
end
