require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    @user = users(:shinji)
    @followee = users(:chikuwa)
    @not_followee = users(:emiya)
  end

  test 'should get home' do
    get pages_home_url
    assert_response :success
  end

  test 'should get about' do
    get about_url
    assert_response :success
  end

  test 'show followees tweet only in timeline' do
    login_as(@user)

    get root_path
    assert_select 'div.nweet-feed a[href=?]', user_path(@followee)
    assert_select 'div.nweet-feed a[href=?]', user_path(@not_followee), count: 0
  end

  test 'show every tweet in global timeline' do
    login_as(@user)

    get explore_path
    assert_select 'div.nweet-feed a[href=?]', user_path(@followee)
    assert_select 'div.nweet-feed a[href=?]', user_path(@not_followee)
  end

  test 'can mute user in followees feed' do
    login_as @user
    get explore_path
    assert_select 'div.nweet-feed a[href=?]', user_path(@not_followee)

    post mute_path(mutee: @not_followee)
    get explore_path
    # TODO: おすすめでもミュート機能を適用
    # assert_no_match user_path(@not_followee), response.body
    assert_select 'div.nweet-feed a[href=?]', user_path(@not_followee), count: 0
  end

  test 'can search nweets in explore feed' do
    nweet_with_tag = nweets(:featured)
    nweet_with_statement = nweets(:femdom_statement)

    get explore_path(q: '男性受け')
    assert_select 'div.nweet-feed a[href=?]', nweet_path(nweet_with_tag)
    assert_select 'div.nweet-feed a[href=?]', nweet_path(nweet_with_statement)
  end

  test 'scroll test' do
    nweet = nweets(:chirstmas)
    next_nweet = nweets(:eve)
    before = nweet.did_at

    get explore_path(before: before.to_i)
    assert_select 'li.nweet a[href=?]', nweet_path(next_nweet)
  end
end
