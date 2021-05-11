require 'test_helper'

class TermsControllerTest < ActionDispatch::IntegrationTest
  test 'get privacy policy' do
    get privacy_path
    assert_response :success
  end

  test 'get for creators' do
    get for_creators_path
    assert_response :success
  end
end
