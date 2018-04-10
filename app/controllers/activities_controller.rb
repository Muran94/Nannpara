class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def show
    period = _convert_period_to_date_object
    @speak_count = current_user.activities.where(activity_type: ActivityType.find_by_name_ja("声かけ")).where('created_at >= ?', period).count
    @tel_count = current_user.activities.where(activity_type: ActivityType.find_by_name_ja("番ゲ")).where('created_at >= ?', period).count
    @date_count = current_user.activities.where(activity_type: ActivityType.find_by_name_ja("連れ出し")).where('created_at >= ?', period).count
    @sex_count = current_user.activities.where(activity_type: ActivityType.find_by_name_ja("即")).where('created_at >= ?', period).count
  end

  def create
    @activities = current_user.activities.build(_activities_params)
    flash[:error] = '不正な操作です。もう一度やり直してください。' unless @activities.save
    redirect_to activities_path(period: params['period'])
  end

  def destroy
    @activities = current_user.activities.order("created_at DESC").where(activity_type_id: params[:activity_type_id]).first

    if @activities.nil? # 該当のカウント件数が０件の場合
      flash[:error] = "不正な操作です。もう一度やり直してください。"
    else
      @activities.destroy
    end
    redirect_to activities_path(period: params['period'])
  end

  private

  def _activities_params
    params.permit(:activity_type_id)
  end

  def _convert_period_to_date_object
    case params['period']
    when '本日'
      Date.today.beginning_of_day
    when '週間'
      1.week.ago.beginning_of_day
    when '月間'
      1.month.ago.beginning_of_day
    else
      params['period'] = '本日'
      1.day.ago.beginning_of_day
    end
  end
end
