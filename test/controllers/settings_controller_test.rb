require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:chikuwa)
  end

  test "should get settings(root) when logged-in" do
    get settings_url
    assert_redirected_to new_user_session_path

    login_as(@user)
    get settings_url
    assert_response :success
  end

end
