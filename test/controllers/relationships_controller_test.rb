require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!

    @user = users(:chikuwa)
    @other_user = users(:shinji)

    login_as(@user)
  end

  test 'can follow and unfollow users' do
    post relationship_path(followee: @other_user)
    assert_redirected_to root_path

    delete relationship_path(followee: @other_user)
    assert_redirected_to root_path

    post relationship_path(followee: @other_user), xhr: true
    assert_response :no_content

    delete relationship_path(followee: @other_user), xhr: true
    assert_response :no_content
  end
end
