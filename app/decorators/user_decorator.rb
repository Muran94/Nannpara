module UserDecorator
  UNSET_MESSAGE = '未登録'.freeze

  def format_introduction
    introduction.blank? ? UNSET_MESSAGE : introduction
  end

  def format_age
    age.blank? ? UNSET_MESSAGE : "#{age}歳"
  end

  def format_prefecture
    prefecture_code.blank? ? UNSET_MESSAGE : prefecture.name
  end

  def format_experience
    experience.blank? ? UNSET_MESSAGE : experience
  end

  def format_image_url(size = nil)
    return 'no_user_image.png' if image.blank?
    case size
    when nil
      image_url
    when 'thumb'
      image.thumb.url
    else
      'no_user_image.png'
    end
  end
end
