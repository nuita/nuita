# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.delivery_method = :smtp

  if Rails.application.credentials.ses
    config.action_mailer.smtp_settings = {
      address: Rails.application.credentials.ses.fetch(:address),
      port: 587,
      domain: Rails.application.credentials.ses.fetch(:domain),
      authentication: :login,
      user_name: Rails.application.credentials.ses.fetch(:access_key),
      password: Rails.application.credentials.ses.fetch(:secret_key),
      enable_starttls_auto: true
    }
  end
end
