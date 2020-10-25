require 'test_helper'

class MutesControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:chikuwa)
    @other_user = users(:shinji)
  end

  test 'can mute and unmute users' do
    assert_no_difference 'Mute.count' do
      post mute_path(user: @other_user), xhr: true
    end

    login_as(@user)
    post mute_path(user: @other_user), xhr: true
    assert @user.muted?(@other_user)

    delete mute_path(user: @other_user), xhr: true
    assert_not @user.muted?(@other_user)
  end
end
