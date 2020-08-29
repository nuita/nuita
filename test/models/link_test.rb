require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  test 'fetch data correctly as created' do
    # hikakinTV
    url = 'https://www.youtube.com/user/HikakinTV'
    @link = Link.fetch_from(url)
    assert_not_nil @link

    assert_equal 'HikakinTV', @link.title
    assert_match 'ヒカキン', @link.description
    assert_not_empty @link.image

    # instagram
    url = 'https://www.instagram.com/'
    @link = Link.fetch_from(url)
    assert_not_nil @link

    assert_equal 'Instagram', @link.title
    assert_match 'Instagram', @link.description
    assert_not_empty @link.image

    # example.com (カード情報ない)
    url = 'http://example.com'
    @link = Link.fetch_from(url)
    assert_not_nil @link
    assert_equal 'Example Domain', @link.title
    assert_empty @link.description
  end

  test 'link can set and remove tag' do
    link = Link.fetch_from('https://www.pixiv.net/member_illust.php?mode=medium&illust_id=76477824')

    link.set_tag('R-18G')
    assert link.tags.exists?(name: 'R-18G')

    other_link = Link.fetch_from('https://twitter.com/hidesys/status/1162036947939807232')
    assert_no_difference 'Tag.count' do
      other_link.set_tag('R-18G')
    end

    link.remove_tag('R-18G')
    assert_not link.tags.exists?(name: 'R-18G')

    # how about multiple tags?
    link.set_tags(["R-18G", "ふたなり"])
    assert link.tags.exists?(name: 'ふたなり')
    assert link.tags.exists?(name: 'R-18G')

    link.set_tags(["リョナ"], destroy_existing_tags: false)
    assert link.tags.exists?(name: 'リョナ')
    assert link.tags.exists?(name: 'ふたなり')

    link.remove_tags
    assert_equal 0, link.tags.count
  end
end
