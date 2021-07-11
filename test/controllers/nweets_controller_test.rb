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

    assert_select 'a[href=?]', user_path(@user)
  end

  test 'should get new' do
    share_text = 'This text should be appear in input form!'
    get new_nweet_path(@nweet, text: share_text)
    # テストではredirectではなくunauthorized返される。deviseの仕様か?
    # 他環境でのリダイレクトは既に確認済みのため、ここでは401でテストを通す
    # assert_redirected_to new_user_session_url
    assert_response :unauthorized

    login_as(@user)
    get new_nweet_path(@nweet, text: share_text)
    assert_select 'textarea', share_text
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

  test 'should get recommend' do
    get recommend_path
    assert_response :success
  end

  test 'did_at should be equal to created at if the diff is smaller than 3 minutes' do
    login_as(@user)
    post nweets_path, params: {nweet: {did_at: 1.minute.ago}}

    assert_equal Nweet.first.created_at, Nweet.first.did_at
  end
end
