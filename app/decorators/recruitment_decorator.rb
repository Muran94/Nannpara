module RecruitmentDecorator
  def format_image_url(size = nil)
    return 'no_user_image.png' if user.blank?
    return 'no_user_image.png' if user.image.blank?
    case size
    when nil
      user.image_url
    when 'thumb'
      user.image.thumb.url
    else
      'no_user_image.png'
    end
  end

  def default_input_value_for_event_date
    event_date.present? ? event_date.strftime("%Y/%m/%d") : Time.zone.now.strftime("%Y/%m/%d")
  end

  def default_input_option_for_prefecture_code
    if current_user.prefecture_code.present?
      {selected: current_user.prefecture_code}
    else
      {prompt: "選択してください。"}
    end
  end

  def format_created_at
    _format_date_time(created_at)
  end

  def format_short_created_at
    _format_short_date_time(created_at)
  end

  def format_event_date
    _format_date(event_date)
  end

  def format_short_event_date
    _format_shot_date(event_date)
  end

  def shortened_description
    if description.length > 256
      "#{description[0..256]} ..."
    else
      description
    end
  end

  private

  def _format_date(date)
    date.strftime('%Y年%m月%d日')
  end

  def _format_shot_date(date)
    date.strftime('%m/%d')
  end

  def _format_date_time(date_time)
    date_time.strftime('%Y年%m月%d日 %H時%M分')
  end

  def _format_short_date_time(date_time)
    date_time.strftime('%m/%d %H:%M')
  end
end
