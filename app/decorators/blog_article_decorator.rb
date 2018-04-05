module BlogArticleDecorator
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
