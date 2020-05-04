require 'test_helper'

class NotificationControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:chikuwa)
    @other_user = users(:emiya)
    @nweet = nweets(:saytwo)
  end

  test "should get index when logged-in" do
    get notifications_path
    assert_redirected_to new_user_session_url

    login_as(@user)
    get notifications_path
    assert_response :success
  end
end
