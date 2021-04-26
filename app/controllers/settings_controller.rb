class SettingsController < ApplicationController
  before_action :authenticate_user!

  def account
  end

  def contents
  end

  def security
  end

  def mutes
    @user = current_user
    @users = current_user.muted_users
    @topic = 'ミュート中のユーザー'

    render_users(@users, 'settings/show_users')
  end
end
