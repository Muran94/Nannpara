class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :_configure_permitted_parameters, if: :devise_controller?
  before_action :_basic_auth if Rails.env.staging?

  protected

  def _configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :direct_mail])
  end

  private

  def _basic_auth
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == Settings.security.staging_basic_auth.user_name && password == Settings.security.staging_basic_auth.password
    end
  end
end
