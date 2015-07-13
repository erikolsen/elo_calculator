class SessionsController < ApplicationController
  def create
    facebook_account = FacebookAccount.from_omniauth(env["omniauth.auth"])
    session[:facebook_account_id] = facebook_account.id
    redirect_to root_url
  end

  def destroy
    session[:facebook_account_id] = nil
    redirect_to root_url
  end

end
