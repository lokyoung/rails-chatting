class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.page(params[:page])
  end

  def join_room_request
    if NotificationService.deal_with_join_request(params, current_user, notification_params)
      flash[:success] = 'Please wait for accepet.'
    end
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  def accept_request
    @notification = NotificationService.deal_with_accept_request(params, current_user)
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  def reject_request
    @notification = NotificationService.deal_with_reject_request(params, current_user)
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  private

  def notification_params
    @params.require(:notification).permit(:content)
  end

end
