module MessageDecorator
  def format_user_name
    user.present? ? user.name : '南原さん'
  end

  def users_thumb_image_url
    if user.present? && user.image.present?
      user.image.thumb.url
    else
      'no_user_image.png'
    end
  end
end
