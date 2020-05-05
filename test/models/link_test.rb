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

  test 'fetch canonical url' do
    url = 'https://blog.hubspot.jp/canonical-url?hogehoge=1'
    @link = Link.fetch_from(url)
    assert_equal 'https://blog.hubspot.jp/canonical-url', @link.url

    # it's ok if you don't have canonical url
    url = 'https://example.com/'
    @link = Link.fetch_from(url)
    assert_equal 'https://example.com/', @link.url
  end

  test 'fetch nijie correctly' do
    url = 'https://sp.nijie.info/view_popup.php?id=319985'
    @link = Link.fetch_from(url)

    assert_equal 'https://nijie.info/view.php?id=319985', @link.url
    assert_match '発情めめめ', @link.title

    url = 'https://nijie.info/view.php?id=319985'
    assert_match @link.url, url

    # アニメはサムネに留めておく
    url = 'http://nijie.info/view.php?id=177736'
    @link = Link.fetch_from(url)

    assert_match '__rs_l160x160', @link.image

    # cf: issue #59
    url = 'https://nijie.info/view.php?id=322323'
    @link = Link.fetch_from(url)

    assert_equal 'https://pic.nijie.net/05/nijie_picture/3965_20190710041444_0.png', @link.image
    assert_equal 1764, @link.image_width
    assert_equal 1876, @link.image_height
  end

  test 'fetch pixiv correctly' do
    url = 'https://www.pixiv.net/member_illust.php?mode=medium&illust_id=75763842'
    @link = Link.fetch_from(url)

    assert_match '地鶏', @link.title
    assert_equal 'https://pixiv.cat/75763842.jpg', @link.image

    # これは完全に冗長なテストだけどかわいいから見て
    url = 'https://www.pixiv.net/member_illust.php?mode=medium&illust_id=73718144'
    @link = Link.fetch_from(url)

    assert_match 'んあー・・・', @link.title
    assert_match 'ん？あげませんよ！', @link.description
    assert_equal 'https://pixiv.cat/73718144.jpg', @link.image

    # manga. これで抜く人いなそう
    url = 'https://www.pixiv.net/member_illust.php?mode=medium&illust_id=75871400'
    @link = Link.fetch_from(url)

    assert_match 'DWU', @link.title
    assert_match '浅瀬', @link.description
    assert_equal 'https://pixiv.cat/75871400-1.jpg', @link.image

    # URLの形式変わってるやんけ
    url = 'https://www.pixiv.net/artworks/78296385'
    @link = Link.fetch_from(url)

    assert_match '女子大生セッッ', @link.title
    assert_match 'ノポン人', @link.description
    assert_equal 'https://pixiv.cat/78296385-1.jpg', @link.image
  end

  test 'fetch melonbooks correctly' do
    url = 'https://www.melonbooks.co.jp/detail/detail.php?product_id=319663'

    @link = Link.fetch_from(url)
    assert_match 'https://www.melonbooks.co.jp/detail/detail.php?product_id=319663&adult_view=1', @link.url
    assert_match 'めちゃシコごちうさアソート', @link.title
    assert_match 'image=212001143963.jpg', @link.image
    assert_no_match 'c=1', @link.image
    assert_match 'めちゃシコシリーズ', @link.description

    # スタッフの推薦文ない作品は構造変わるからテスト
    url = 'https://www.melonbooks.co.jp/detail/detail.php?product_id=242938'
    @link = Link.fetch_from(url)

    assert_match 'ぬめぬめ', @link.title
    assert_match '諏訪子様にショタがいじめられる話です。', @link.description #かわいそう…
  end

  test 'fetch komiflo correctly' do
    url = 'https://komiflo.com/#!/comics/4635/read/page/3'
    @link = Link.fetch_from(url)

    assert_equal 'https://komiflo.com/comics/4635', @link.url
    assert_match '晴れ時々露出予報', @link.title
    assert_match 'NAZ', @link.description
    assert_equal 'https://t.komiflo.com/564_mobile_large_3x/contents/cdcfb81ea67a74519b8ad9dea6de8c5d4cec9f9f.jpg', @link.image
  end

  test 'fetch dlsite correctly' do
    url = 'https://www.dlsite.com/maniax-touch/dlaf/=/t/p/link/work/aid/miuuu/id/RJ255695.html'
    @link = Link.fetch_from(url)

    assert_match '性欲処理される生活。', @link.title
    assert_match '事務的な双子メイドが、両耳から囁きながら、ご主人様のおちんぽのお世話をしてくれます♪', @link.description
    assert_equal 'https://img.dlsite.jp/modpub/images2/work/doujin/RJ256000/RJ255695_img_main.jpg', @link.image
  end

  test 'link can have tag' do
    link = Link.fetch_from('https://www.pixiv.net/member_illust.php?mode=medium&illust_id=76477824')
    assert link.valid?

    tag = link.tags.create!(name: 'R-18G')
    assert tag.valid?
    assert link.valid?
  end

  test 'link can set and remove tag' do
    link = Link.fetch_from('https://www.pixiv.net/member_illust.php?mode=medium&illust_id=76477824')

    link.set_tag('R18G')
    assert link.tags.exists?(name: 'R18G')

    other_link = Link.fetch_from('https://twitter.com/hidesys/status/1162036947939807232')
    assert_no_difference 'Tag.count' do
      other_link.set_tag('R18G')
    end

    link.remove_tag('R18G')
    assert_not link.tags.exists?(name: 'R18G')

    # how about multiple tags?
    link.set_tags(["R18G", "ふたなり"])
    assert link.tags.exists?(name: 'ふたなり')
    assert link.tags.exists?(name: 'R18G')

    link.set_tags(["リョナ"], destroy_existing_tags: false)
    assert link.tags.exists?(name: 'リョナ')
    assert link.tags.exists?(name: 'ふたなり')

    link.remove_tags
    assert_equal 0, link.tags.count
  end
end
