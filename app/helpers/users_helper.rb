module UsersHelper
  # change str to screen_name format ("Screen Name" -> "Screen_Name")
  def self.screen_name_formatter(str)
    str.tr(' ', '_')
  end

  # urlだけ返す 設定なしならデフォルト
  def icon_url(user, size)
    if Rails.env.development? || user.nil? || user.icon.url.nil?
      image_pack_path('icon_default.png')
    else
      size <= 60 ? user.icon.thumb.url : user.icon.url
    end
  end

  # さらにicon_urlをimageタグを返してくれる
  def icon_for(user, size: 80, htmlclass: 'rounded-circle')
    if user.present?
      alt = user.handle_name
      id = "usericon-#{user.id}"
    else
      alt = ''
      id = 'usericon-default'
    end
    image_tag(icon_url(user, size), alt: alt, size: size.to_s, class: htmlclass, id: id)
  end

  def current_user?(user)
    user == current_user
  end

  def friend?(user)
    user == current_user || (user.followee?(current_user) && user.follower?(current_user))
  end

  # 「自分がログイン済みで、かつ相手が自分以外のユーザーかどうか」
  def other_user?(user)
    !!current_user && current_user != user
  end

  def followee_or_self?(user)
    current_user == user || current_user.followee?(user)
  end

  # 1つめの返り値は日にちごとのヌイートが入ったハッシュ、2つめは開始日
  def contribution_for(user, row)
    # カレンダーの内訳: (row - 1)行分の完全な週 + 日曜〜今日まで
    start_day = Date.current.beginning_of_week(:sunday) - (row - 1).week
    nweets = user.nweets.where(created_at: start_day..Time.current)

    hash = calendarize_data(nweets, column: :did_at)

    [hash, start_day]
  end

  def calendar_tooltip(date, count)
    "<span class='calendar-tooltip'>#{t('.nweet_count', count: count)} <span class='text-secondary'>#{date}</span></span>"
  end
end
