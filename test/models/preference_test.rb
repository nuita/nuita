require 'test_helper'

class PreferenceTest < ActiveSupport::TestCase
  def setup
    @user = users(:chikuwa)
    @tag = tags(:r18g)
    @another_tag = tags(:three_d)
  end

  test 'user and tag have to be present and unique, regardless of what the context is' do
    preference = Preference.create(user: @user, tag: @tag, context: :censoring)
    assert preference.valid?

    preference = Preference.new(tag: @tag, context: :censoring)
    assert_not preference.valid?

    preference = Preference.new(user: @user, context: :censoring)
    assert_not preference.valid?

    preference = Preference.new(user: @user, tag: @tag, context: :censoring)
    assert_not preference.valid?

    preference = Preference.new(user: @user, tag: @tag, context: :preferring)
    assert_not preference.valid?
  end

  test 'destroy when tag or user is destroyed' do
    Preference.create(user: @user, tag: @tag, context: :censoring)
    assert_difference 'Preference.count', -1 do
      @tag.destroy
    end

    Preference.create(user: @user, tag: @another_tag, context: :censoring)
    assert_difference 'Preference.count', -1 do
      @user.destroy
    end
  end
end
