module NweetsHelper
  # デフォのtime_ago_in_wordsのままだと「1分以内前」ってなっちゃうので…
  def time_ago_in_japanese(time)
    str = time_ago_in_words(time)
    if str.last(2) == "以内"
      str
    else
      str + "前"
    end
  end

  def enough_interval?(time = Time.zone.now)
    time > current_user.nweets.first.did_at + 3.minutes
  end

  def delete_possible?(did_at, user)
    did_at > 1.hour.ago && user == current_user
  end

  def likes_number(nweet)
    if nweet.likes.count > 0
      nweet.likes.count
    else
      nil
    end
  end

  def link_visible?(nweet)
    case nweet.privacy.to_sym
    when :to_everyone
      true
    when :to_followers
      current_user && followee_or_self?(nweet.user)
    when :to_author_only
      current_user && current_user == nweet.user
    end
  end
end
