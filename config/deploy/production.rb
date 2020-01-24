server 'nuita.net', user: Rails.application.credentials.deploy[:username], roles: %w{app db web}, port: 22

set :ssh_options, keys: Rails.application.credentials.deploy[:ssh_key_path]
