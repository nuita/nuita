require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    Warden.test_mode!
    @user = users(:chikuwa)
    @shinji = users(:shinji)
  end

  test 'should get show' do
    assert_not_equal user_path(@user), "/users/#{@user.id}"
    assert_equal user_path(@user), "/users/#{@user.url_digest}"

    get user_path(@user)
    assert_response :success
  end

  test 'associated nweets must be destroyed' do
    assert_difference 'Nweet.count', -1 do
      @shinji.destroy
    end
  end

  test 'nweets should have interval of 3 min' do
    @user.nweets.create!(did_at: 2.minutes.ago)
    nweet = @user.nweets.build(did_at: Time.zone.now)
    assert_not nweet.valid?
  end

  # have to make add test (but how?)
  test 'can delete twitter account' do
    assert_not_empty @user.twitter_uid
    @user.delete_twitter_account
    assert_nil @user.twitter_uid
    assert_nil @user.twitter_url
    assert_nil @user.twitter_screen_name
  end

  test 'autotweet is disabled when delete twitter account' do
    @user.autotweet_enabled = true
    @user.delete_twitter_account

    assert_not @user.autotweet_enabled
  end

  test 'anyone can see followees and followers' do
    get followees_user_path(@shinji)
    assert_response :success

    get followers_user_path(@shinji)
    assert_response :success
  end

  test 'should show or hide biography' do
    get user_path(@shinji)
    assert_match @shinji.biography, response.body

    login_as @user
    post relationship_path(followee: @shinji)
    get user_path(@shinji)
    assert_match @shinji.biography, response.body
  end

  test 'can mute user in global feed' do
    login_as @user
    patch tweak_users_path, params: {user: {feed_scope: :global}}
    get root_path
    assert_match @shinji.screen_name, response.body

    post mute_path(mutee: @shinji)
    get root_path
    assert_no_match @shinji.screen_name, response.body
  end

  test 'can mute user in followees feed' do
    login_as @user
    post relationship_path(followee: @shinji)
    get root_path
    assert_match @shinji.screen_name, response.body

    post mute_path(mutee: @shinji)
    get root_path
    assert_no_match @shinji.screen_name, response.body
  end

  test 'show nweets by date' do
    # nweets(:christmas) 参照
    get user_path(@user, date: '2017-12-25'.to_time)
    assert_match '😢', response.body
  end

  test 'can tweak settings' do
    login_as @user

    patch tweak_users_path, params: {user: {feed_scope: :global}}
    assert @user.global?
  end
end
