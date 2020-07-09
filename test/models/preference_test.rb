require 'test_helper'

class PreferenceTest < ActiveSupport::TestCase
  def setup
    @user = users(:chikuwa)
    @tag = tags(:r18g)
    @another_tag = tags(:three_d)
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

  test 'destroy when tag or user is destroyed' do
    Preference.create(user: @user, tag: @tag)
    assert_difference 'Preference.count', -1 do
      @tag.destroy
    end

    Preference.create(user: @user, tag: @another_tag)
    assert_difference 'Preference.count', -1 do
      @user.destroy
    end    
  end
end
