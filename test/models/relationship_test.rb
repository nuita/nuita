require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user = users(:chikuwa)
    @other_user = users(:shinji)
    @relationship = Relationship.create(follower_id: users(:chikuwa).id, followee_id: users(:shinji).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followee_id = nil
    assert_not @relationship.valid?
  end


  test 'relationship creates and destroys notification' do
    notification = @relationship.notification

    assert notification.follow?
    assert_equal @user.id, notification.origin_id
    assert_equal @other_user.id, notification.destination_id

    assert_difference('Notification.count', -1) do
      notification.destroy
    end
  end
end
