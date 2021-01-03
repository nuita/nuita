require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:chikuwa)
    @nweet = nweets(:today)
    @new_user = users(:girl)
    @not_followee = users(:shinji)
    @followee = users(:emiya)
    @old_user = users(:zoken)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'screen name should be valid' do
    @user.screen_name = ' '
    assert_not @user.valid?

    @user.screen_name = 'a' * 100
    assert_not @user.valid?

    @user.screen_name = 'マイケル'
    assert_not @user.valid?
  end

  test 'user name should be unique (case insensitive)' do
    new_user = User.new(screen_name: 'CHiKUWA', email: 'abcdefg@hijkl.com', password: 'abcdefgh')
    assert_not new_user.valid?

    new_user.screen_name = '_chikuwa_'
    assert new_user.valid?
  end

  test 'handle name should be valid' do
    @user.handle_name = 'a' * 100
    assert_not @user.valid?

    # handle name can be blank
    @user.handle_name = ' '
    assert @user.valid?
  end

  test 'url_digest must be generated' do
    new_user = User.new(screen_name: 'kaburanai', email: 'kaburan@gmail.com', password: 'hogehoge')
    new_user.save
    assert_not_empty new_user.url_digest
  end

  test 'associated nweets must be destroyed' do
    @new_user.save
    @new_user.nweets.create!(did_at: Time.zone.now)
    assert_difference 'Nweet.count', -1 do
      @new_user.destroy
    end
  end

  test 'associated likes must be destroyed' do
    @new_user.save
    @new_user.likes.create!(nweet: @nweet)
    assert_difference 'Like.count', -1 do
      @new_user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    assert_not @user.followee?(@new_user)
    @user.follow(@new_user)
    assert @user.followee?(@new_user)
    assert @new_user.follower?(@user)
    @user.unfollow(@new_user)
    assert_not @new_user.followee?(@user)
  end

  test 'should censor and uncensor tag' do
    tag = tags(:r18g)
    @user.censor(tag)
    assert @user.censoring?(tag.name)

    @user.uncensor(tag)
    assert_not @user.censoring?(tag.name)

    @user.censor(tag.name)
    assert @user.censoring?(tag)
  end

  test 'can prefer and disprefer tag' do
    tag = tags(:kemo)
    @user.prefer(tag)
    assert @user.preferring?(tag.name)

    @user.disprefer(tag)
    assert_not @user.preferring?(tag.name)

    @user.prefer(tag.name)
    assert @user.preferring?(tag)
  end

  test 'followees feed should include preferred tags' do
    n = @new_user.nweets.create(did_at: Time.zone.now, statement: 'https://example.com/ #KEMO')
    assert_not @user.followees_feed.include?(n)

    @user.prefer('KEMO')
    assert_includes @user.followees_feed, n
  end

  test 'nweets in timeline and followees feed must be distinct' do
    assert_equal Nweet.global_feed, Nweet.global_feed.uniq
    assert_equal @user.followees_feed, @user.followees_feed.uniq
  end

  test 'can announce' do
    str = '<h6>寄付のお願い</h6><p>詳細は<a href="https://google.com">こちら</a></p>'
    notification = @user.announce(str)
    assert notification.announce?
    assert_equal str, notification.statement
  end

  test 'create censoring when a user is created' do
    user = User.create(screen_name: 'kaburanai', email: 'kaburan@gmail.com', password: 'hogehoge')

    assert user.censoring?('R-18G')
    assert_not user.censoring?('KEMO')
  end

  test 'can add and remove badges' do
    badge = badges(:christmas)
    @user.badges << badge
    assert @user.badges.exists?

    @user.badges.destroy(badge)
    assert_not @user.badges.exists?
  end

  test 'cannot censor a tag twice' do
    @user.censor 'ふたなり'

    assert_no_difference '@user.censorings.count' do
      @user.censor 'ふたなり'
    end
  end

  test 'can change timeline content based on feed_scope' do
    new_user = User.new(screen_name: 'kaburanai', email: 'kaburan@gmail.com', password: 'hogehoge')
    new_user.save

    # Feed scope should be set followees only by default, thus you can't see nweets by the others.
    assert_empty new_user.timeline.where(user: @not_followee)

    # So, if you follow someone, you can see their nweets.
    new_user.follow(@followee)

    assert_not_empty new_user.timeline.where(user: @followee)

    # And you can set feed scope global. Then you will have all nweets in the world.

    new_user.update_attribute(:feed_scope, :global)
    assert_not_empty new_user.timeline.where(user: @not_followee)
  end

  test 'followees feed can be include nweets without link' do
    nweet = @followee.nweets.create(did_at: Time.zone.now)
    assert_includes @user.followees_feed, nweet
  end

  test 'new follower should be first' do
    # followee and follower should be ordered by when the follow was made,
    # not by when the users themselves were created.
    assert_equal @old_user, @user.followees.first
    assert_equal @followee, @user.followees.second

    assert_equal @old_user, @user.followers.first
    assert_equal @followee, @user.followers.second
  end
end
