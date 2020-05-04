require 'test_helper'

class NweetsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @nweet = nweets(:today)
    @friend_nweet = nweets(:yesterday)
    @user = users(:chikuwa)
  end

  test 'should get show' do
    assert_not_equal nweet_path(@nweet), "/nweets/#{@nweet.id}"
    assert_equal nweet_path(@nweet), "/nweets/#{@nweet.url_digest}"

    get nweet_path(@nweet)
    assert_response :success

    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', user_path(@user)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Nweet.count' do
      post nweets_path, params: {nweet: {did_at: Time.zone.now}}
    end
    assert_redirected_to new_user_session_path
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Nweet.count' do
      delete nweet_path(@nweet)
    end
    assert_redirected_to new_user_session_path
  end

  test 'logged-in user can create their own nweet' do
    login_as(@user)
    assert_difference('Nweet.count', 1) do
      post nweets_path, params: {nweet: {did_at: Time.zone.now}}
    end
    # post request doesn't contain user info, so no need to check correct user
  end

  test 'logged-in user can delete their own nweet' do
    login_as(@user)

    assert_no_difference('Nweet.count') do
      delete nweet_path(@friend_nweet)
    end

    assert_difference('Nweet.count', -1) do
      delete nweet_path(@nweet)
    end
  end

  test 'logged-in user can edit their own nweet' do
    login_as(@user)

    patch nweet_path(@nweet), params: {nweet: {statement: '誰だ今の'} }
    @nweet.reload
    assert_equal '誰だ今の', @nweet.statement

    patch nweet_path(@friend_nweet), params: {nweet: {statement: '誰だ今の'} }
    @friend_nweet.reload
    assert_not_equal '誰だ今の', @friend_nweet.statement
  end

  test 'can set tags when create nweet' do
    login_as(@user)

    gro_url = 'https://dic.pixiv.net/a/R-18G'
    post nweets_path, params: {nweet: {statement: gro_url, did_at: 1.minute.ago}, tags: {'R18G': '1', '3D': '0'} }
    link = Link.find_by(url: gro_url)
    assert link.tags.exists?(name: 'R18G')
    assert_not link.tags.exists?(name: '3D')
  end
end
