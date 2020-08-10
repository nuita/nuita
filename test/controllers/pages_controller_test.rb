require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    @user = users(:shinji)
    @followee = users(:chikuwa)
    @not_followee = users(:emiya)
  end

  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get about" do
    get pages_about_url
    assert_response :success
  end

  test 'show followees tweet only in timeline' do
    login_as(@user)

    get root_path
    assert_match @followee.handle_name, response.body
    assert_no_match @not_followee.handle_name, response.body
  end

  test 'show every tweet in global timeline' do
    login_as(@user)

    get explore_path
    assert_match @followee.handle_name, response.body
    assert_match @not_followee.handle_name, response.body
  end
end
