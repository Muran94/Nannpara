module CountersHelper
  def activate_tab_if_period(period)
    'active' if params['period'] == period
  end
end
