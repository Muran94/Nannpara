module RecruitmentDecorator
  def format_created_at
    _format_date_time(created_at)
  end

  def format_event_date
    _format_date_time(event_date)
  end

  def format_user_name
    user.present? ? user.name : "南原さん"
  end

  private

  def _format_date_time(date_time)
    date_time.strftime("%Y年%m月%d日 %H時%M分")
  end
end
