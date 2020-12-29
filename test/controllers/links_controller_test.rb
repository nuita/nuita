require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:chikuwa)
  end

  test 'should get recommend' do
    get links_recommend_path
    assert_response :success
  end
end
