require 'test_helper'

class PreferringsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:chikuwa)
  end

  test 'can add and delete preferring' do
    assert_no_difference 'Preference.count' do
      post preferring_path(tag: 'ふたなり'), xhr: true
    end

    login_as(@user)
    post preferring_path(tag: 'ふたなり'), xhr: true
    assert @user.preferring?('ふたなり')

    delete preferring_path(tag: 'ふたなり'), xhr: true
    assert_not @user.preferring?('ふたなり')
  end

  test 'cannot delete preferring when not logged-in' do
    assert_no_difference 'Preference.count' do
      delete preferring_path(tag: 'R18G'), xhr: true
    end
  end
end
