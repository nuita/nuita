if Rails.application.credentials.twitter
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter, Rails.application.credentials.twitter[:api_key], Rails.application.credentials.twitter[:api_secret]
  end
else
  OmniAuth.config.test_mode = true;
end
