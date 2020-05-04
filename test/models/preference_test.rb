require 'test_helper'

class PreferenceTest < ActiveSupport::TestCase
  def setup
    @user = users(:chikuwa)
    @tag = tags(:r18g)
  end

  test "user and tag have to be present, but don't have to be unique" do
    preference = Preference.create(user: @user, tag: @tag)
    assert preference.valid?

    no_user_preference = Preference.new(tag: @tag)
    assert_not no_user_preference.valid?

    no_tag_preference = Preference.new(user: @user)
    assert_not no_tag_preference.valid?

    dup_preference = Preference.new(user: @user, tag: @tag)
    assert dup_preference.valid?
  end
end
