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
    assert_equal 'Panchira::Resolver', @link.resolver

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
    link.set_tags(['R-18G', 'ふたなり'])
    assert link.tags.exists?(name: 'ふたなり')
    assert link.tags.exists?(name: 'R-18G')

    link.set_tags(['リョナ'], destroy_existing_tags: false)
    assert link.tags.exists?(name: 'リョナ')
    assert link.tags.exists?(name: 'ふたなり')

    link.remove_tags
    assert_equal 0, link.tags.count
  end

  test 'user-set tag must not be removed by refetch' do
    link = Link.fetch_from('https://www.pixiv.net/artworks/55434358')
    link.set_tag('R-18G')

    link.refetch
    assert link.tags.exists?(name: 'R-18G')
  end

  test 'certain platform is legal and featurable' do
    # 汎用Resolverだとだめ
    link = Link.fetch_from('https://nuita.net')
    assert_not link.legal?

    # 画像直リンもおすすめには出さない。個人的にはおすすめです
    link = links(:image)
    assert_not link.legal?

    # og:imageつきでDLSiteから取得してるいい感じのやつ
    link = links(:mesugaki)
    assert link.legal?
    assert link.featurable?

    image = link.image
    link.image = nil
    assert link.legal?
    assert_not link.featurable?

    link.image = image
    link.set_tag('R-18G')
    assert link.legal?
    assert_not link.featurable?
  end
end
