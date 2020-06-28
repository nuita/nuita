require 'test_helper'

class CensoringsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:chikuwa)
  end

  test 'can add and delete censoring' do
    assert_no_difference 'Preference.count' do
      post censoring_path(tag: 'ふたなり'), xhr: true
    end

    login_as(@user)
    post censoring_path(tag: 'ふたなり'), xhr: true
    assert @user.censoring?('ふたなり')

    delete censoring_path(tag: 'ふたなり'), xhr: true
    assert_not @user.censoring?('ふたなり')
  end

  test 'cannot delete censoring when not logged-in' do
    assert_no_difference 'Preference.count' do
      delete censoring_path(tag: 'R18G'), xhr: true
    end
  end
end
