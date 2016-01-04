class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.page(params[:page])
  end

  def join_room_request
    if NotificationService.new(params, current_user).deal_with_join_request
      flash[:success] = 'Please wait for accepet.'
    end
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  def accept_request
    @notification = NotificationService.new(params, current_user).deal_with_accept_request
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  def reject_request
    @notification = NotificationService.new(params, current_user).deal_with_reject_request
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

end
