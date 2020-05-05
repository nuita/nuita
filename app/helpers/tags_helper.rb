module TagsHelper
  # 検閲されてるタグの名前を返す. ないなら空集合返ってくる
  def censored_tags(link)
    if user_signed_in?
      link.tags.pluck(:name).select do |tag|
        current_user.censoring?(tag)
      end
    else
      link.tags.where(censored_by_default: true).pluck(:name)
    end
  end

  # R18G, 3D以外のタグは現状表示しない
  def visible_tags
    ['3D', 'R18G']
  end

  def tag_method(is_existing)
    if is_existing
      :delete
    else
      :post
    end
  end

  def tag_icon(is_existing)
    if is_existing
      "times"
    else
      "plus"
    end
  end
end
