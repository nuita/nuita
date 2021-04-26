class TwittersController < ApplicationController
  def create
    current_user.add_twitter_account(request.env['omniauth.auth'])
    redirect_to settings_account_path
  end

  def destroy
    current_user.delete_twitter_account
    redirect_to settings_account_path
  end
end
