module AccountsHelper
  def account_owner?(user)
    return false unless user_signed_in?
    current_user == user
  end
end
