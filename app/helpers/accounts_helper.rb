module AccountsHelper
  def account_owner?(user)
    return false unless user_signed_in?
    current_user == user
  end

  def activate_tab_if_correct_page(action_name)
    'active' if controller.action_name == action_name
  end
end
