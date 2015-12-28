class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.page(params[:page])
  end

  def join_room
    @room = Room.find(params[:id])
    @notification = Notification.new(notification_params.merge(title: "Join request to your room #{@room.name}", actor_id: current_user.id, recipient_id: @room.owner_id, notifiable: @room))
    if @notification.save
      user = @notification.user
      ActionCable.server.broadcast "notification:#{user.id}", { body: user.notifications.unread.count.to_s }
      flash[:success] = 'Please wait for accepet.'
      respond_to do |format|
        format.html { redirect_to rooms_url }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to rooms_url }
        format.js
      end
    end
  end

  def accept_join
    @notification = Notification.find_by(id: params[:id])
    @notification.update_attributes(solved: true)
    @room = Room.find_by(id: @notification.notifiable.id)
    @user = User.find_by(id: @notification.actor_id)
    user_ids = @room.user_ids
    user_ids << @user.id
    @room.user_ids = user_ids
    #render status: 200, json: {message: "success"}
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
