module NweetsHelper
  # デフォのtime_ago_in_wordsのままだと「1分以内前」ってなっちゃうので…
  def time_ago_in_japanese(time)
    str = time_ago_in_words(time)
    if str.last(2) == "以内"
      str
    else
      "#{str}前"
    end
  end

  def enough_interval?(time = Time.zone.now)
    time > current_user.nweets.first.did_at + 3.minutes
  end

  def delete_possible?(did_at, user)
    did_at > 1.hour.ago && user == current_user
  end

  def likes_number(nweet)
    nweet.likes.count if nweet.likes.count > 0
  end
end
