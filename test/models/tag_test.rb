require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'name must be upcase' do
    tag = Tag.new(name: 'yuri')

    tag.save
    assert_equal 'YURI', tag.name

    # uniqueness is not case sensitive
    other_tag = Tag.new(name: 'YURI')
    assert_not other_tag.valid?
  end
end
