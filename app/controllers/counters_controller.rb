class CountersController < ApplicationController
  before_action :authenticate_user!

  def new
    period = _convert_period_to_date_object
    @speak_count = current_user.counters.where(counter_type: '声かけ').where('created_at >= ?', period).count
    @tel_count = current_user.counters.where(counter_type: 'バンゲ').where('created_at >= ?', period).count
    @sex_count = current_user.counters.where(counter_type: '即').where('created_at >= ?', period).count
  end

  def create
    @counter = current_user.counters.build(_counters_params)
    flash[:error] = '不正な操作です。もう一度やり直してください。' unless @counter.save
    redirect_to new_counter_path(period: params['period'])
  end

  def destroy
    @counter = current_user.counters.order("created_at DESC").where(counter_type: params[:counter_type]).first

    if @counter.nil? # 該当のカウント件数が０件の場合
      flash[:error] = "不正な操作です。もう一度やり直してください。"
    else
      @counter.destroy
    end
    redirect_to new_counter_path(period: params['period'])
  end

  private

  def _counters_params
    params.permit(:counter_type)
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
