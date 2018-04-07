module Blog::CommentDecorator
  def format_user_name
    user.present? ? user.name : '南原さん'
  end
end
