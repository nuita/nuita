require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    
    @user = users(:chikuwa)
    @link = links(:kanikama)
  end

  test 'should not create tags unless log in' do
    assert_no_difference 'LinkTag.count' do
      post tag_path(link: @link, name: '巨乳'), xhr: true
    end
  end

  test 'should not delete tags unless log in' do
    assert_no_difference 'LinkTag.count' do
      delete tag_path(link: @link, name: 'R18G'), xhr: true
    end
  end

  test 'create tags' do
    login_as(@user)
    post tag_path(link: @link, name: '巨乳'), xhr: true
    assert @link.tags.exists?(name: '巨乳')
  end

  test 'delete tags' do
    login_as(@user)
    delete tag_path(link: @link, name: 'R18G'), xhr: true
    assert_not @link.tags.exists?(name: 'R18G')
  end
end
