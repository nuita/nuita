module NweetsHelper
  def time_ago(time)
    t('datetime.formats.ago', string: time_ago_in_words(time))
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
