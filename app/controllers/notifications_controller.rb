class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.page(params[:page])
  end

  def join_room_request
    @room = Room.find(params[:id])
    @notification = Notification.new(notification_params.merge(title: "Join request to your room #{@room.name}", actor_id: current_user.id, recipient_id: @room.owner_id, notifiable: @room, n_type: "join_request"))
    if @notification.save
      flash[:success] = 'Please wait for accepet.'
    end
    respond_to do |format|
      format.js
    end
  end

  def accept_request
    @notification = Notification.find_by(id: params[:id])
    @notification.update_attributes(solved: true)
    @room = Room.find_by(id: @notification.notifiable.id)
    # 邀请用户加入房间
    if @notification.n_type == "invite_request"
      @user = User.find_by(id: @notification.recipient_id)
      Notification.create_accept_invite(@notification, current_user)
    elsif @notification.n_type == "join_request"
      #接受用户申请加入房间的请求
      @user = User.find_by(id: @notification.actor_id)
      Notification.create_accept_join(@notification, current_user)
    end
    @room << @user
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  def reject_request
    @notification = Notification.find_by(id: params[:id])
    @notification.update_attributes(solved: true)
    if @notification.n_type == "invite_request"
      Notification.create_reject_invite(@notification, current_user)
    elsif @notification.n_type == "join_request"
      Notification.create_reject_join(@notification, current_user)
    end
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.js
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:content)
  end

end
