require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:chikuwa)
    @other_user = users(:shinji)
  end

  test 'should get account settings when logged-in' do
    get settings_url
    assert_redirected_to new_user_session_path

    login_as(@user)
    get settings_account_path
    assert_response :success
  end

  test 'should get muted users when logged-in' do
    get settings_mutes_path
    assert_redirected_to new_user_session_path

    login_as(@user)
    get settings_mutes_path
    assert_no_match @other_user.screen_name, response.body

    post mute_path(mutee: @other_user), xhr: true
    get settings_mutes_path
    assert_match @other_user.screen_name, response.body
  end
end
