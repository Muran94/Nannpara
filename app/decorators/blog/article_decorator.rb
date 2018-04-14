module Blog::ArticleDecorator
  def format_image_url(size = nil)
    return Settings.image.no_user_image_file_name if user.blank?
    return Settings.image.no_user_image_file_name if user.image.blank?
    case size
    when nil
      user.image_url
    when 'thumb'
      user.image.thumb.url
    else
      Settings.image.no_user_image_file_name
    end
  end

  def format_short_created_at
    created_at.strftime('%Y年%m月%d日')
  end

  def format_created_at
    created_at.strftime('%Y年%m月%d日 %H時%M分')
  end

  def shortened_description
    if content.length > 256
      "#{content[0..256]} ..."
    else
      content
    end
  end
end
