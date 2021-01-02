require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  def setup
    @user = users(:chikuwa)
    @other_user = users(:emiya)
    @nweet = nweets(:saytwo)
  end

  test 'users are associated correctly to notification' do
    assert_difference -> { @user.active_notifications.count } => 1, -> { @other_user.passive_notifications.count } => 1 do
      Like.create!(user: @user, nweet: @nweet)
    end
  end
end
