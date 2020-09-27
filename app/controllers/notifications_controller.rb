class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @notifications = current_user.passive_notifications.includes(:origin).paginate(page: params[:page], per_page: 100)
    current_user.check_notifications
  end

  def refresh
    c = current_user.passive_notifications.where(checked: false).count
    render plain: c.to_s
  end
end
