require 'test_helper'

class MuteTest < ActiveSupport::TestCase
  def setup
    @user = users(:chikuwa)
    @other_user = users(:shinji)
  end

  test 'muter and mutee must be present and unique' do
    mute = Mute.new(muter: @user)
    assert_not mute.valid?

    mute = Mute.new(mutee: @other_user)
    assert_not mute.valid?

    mute = Mute.new(muter: @user, mutee: @other_user)
    assert mute.valid?
    mute.save

    mute = Mute.new(muter: @user, mutee: @other_user)
    assert_not mute.valid?
  end
end
