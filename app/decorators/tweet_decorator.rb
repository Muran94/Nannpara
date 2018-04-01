module TweetDecorator
  def format_image_url(size = nil)
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
end
