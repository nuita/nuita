require 'test_helper'

class TermsControllerTest < ActionDispatch::IntegrationTest
  test 'get privacy policy' do
    get privacy_path
    assert_response :success
  end
end
