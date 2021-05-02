require 'test_helper'

class TwitterControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!

    @user = users(:chikuwa)
    login_as(@user)
  end

  test 'should add and delete twitter account' do
    post auth_twitter_callback_path
    assert_redirected_to settings_account_path

    delete auth_twitter_path
    assert_redirected_to settings_account_path
  end
end
