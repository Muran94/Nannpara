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

  def format_created_at
    _format_date_time(created_at)
  end

  def format_short_created_at
    _format_short_date_time(date_time)
  end

  def format_event_date
    _format_date_time(event_date)
  end

  def format_short_event_date
    _format_short_date_time(event_date)
  end

  def format_event_venue
    %(#{prefecture.name} > #{venue})
  end

  def shortened_description
    if description.length > 256
      "#{description[0..256]} ..."
    else
      description
    end
  end

  private

  def _format_date_time(date_time)
    date_time.strftime('%Y年%m月%d日 %H時%M分')
  end

  def _format_short_date_time(date_time)
    date_time.strftime('%m/%d %H:%M')
  end
end
