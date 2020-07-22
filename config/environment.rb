# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address: Rails.application.credentials.ses[:address],
    port: 587,
    domain: Rails.application.credentials.ses[:domain],
    authentication: :login,
    user_name: Rails.application.credentials.ses[:access_key],
    password: Rails.application.credentials.ses[:secret_key],
    enable_starttls_auto: true 
  }
end
