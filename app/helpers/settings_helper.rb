module SettingsHelper
  def feed_scope_options
    User.feed_scopes.map { |k, v| [User.human_attribute_name("user.feed_scopes.#{k}"), k] }
  end
end
