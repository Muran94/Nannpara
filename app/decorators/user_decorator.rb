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
    return Settings.image.no_user_image_file_name if image.blank?
    case size
    when nil
      image_url
    when 'thumb'
      image.thumb.url
    else
      Settings.image.no_user_image_file_name
    end
  end
end
