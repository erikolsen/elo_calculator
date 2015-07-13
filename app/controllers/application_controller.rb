class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def current_user
    @current_user ||= FacebookAccount.find(session[:facebook_account_id]) if session[:facebook_account_id]
  end

  helper_method :current_user
end
