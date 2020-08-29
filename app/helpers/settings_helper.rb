module SettingsHelper
  def feed_scope_options
    User.feed_scopes.map { |k, v| [User.human_attribute_name("user.feed_scopes.#{k}"), k] }
  end

  def taglist_id(context)
    "tagsFormTagList#{context}"
  end

  def tags_form_path(context, tag = nil)
    "/#{context}" + (tag ? "?tag=#{tag}" : "")
  end

  def tags_form_items(context)
    case context
    when :preferring
      current_user.preferred_tags
    when :censoring
      current_user.censored_tags
    end
  end
end
