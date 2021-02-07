require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:chikuwa)
    @nweet = nweets(:today)
    @other_nweet = nweets(:saytwo)
  end

  test 'user can like nweet only once' do
    # user can like
    like = @user.likes.create!(nweet: @nweet)
    assert @user.liked?(@nweet)

    # but not twice
    another_like = @user.likes.build(nweet: @nweet)
    assert_not another_like.valid?

    # but after deleting first one...
    like.destroy
    assert another_like.valid?
  end

  test 'like creates and destroys notification' do
    like = @user.likes.create!(nweet: @other_nweet)
    notification = like.notification

    assert notification.like? # 通知の種類(=action)のテスト
    assert_equal @user.id, notification.origin_id
    assert_equal @other_nweet.user.id, notification.destination_id

    assert_difference('Notification.count', -1) do
      like.destroy
    end
  end

  test 'update liked nweet status' do
    featurable_url = 'https://www.melonbooks.co.jp/detail/detail.php?product_id=537453&adult_view=1'
    nweet = @user.nweets.create(did_at: Time.zone.now, statement: "👍 #{featurable_url}")

    assert_nil nweet.latest_liked_time
    assert_not nweet.featured?

    @user.likes.create!(nweet: nweet)

    assert nweet.latest_liked_time > 1.minute.ago
    assert nweet.featured?
  end

  test 'do not notify when user notify nweets by himself' do
    nweet = nweets(:today)

    like = @user.likes.create!(nweet: nweet)
    assert_nil like.notification
  end
end
