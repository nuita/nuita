require 'test_helper'

class ChristmasControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get christmas_url
    assert_response :success
  end
end
